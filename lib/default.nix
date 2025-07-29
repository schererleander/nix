{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
  isDarwin = s: lib.strings.hasSuffix "-darwin" s;
in rec {
  mkSystem =
    { host
    , username
    , system
    , extraModules ? [ ]
    , extraArguments ? { }
    }:
    let
      darwinHost = isDarwin system;
      builder    = if darwinHost
                   then inputs.nix-darwin.lib.darwinSystem
                   else inputs.nixpkgs.lib.nixosSystem;
      hmModule   = if darwinHost
                   then inputs.home-manager.darwinModules.home-manager
                   else inputs.home-manager.nixosModules.home-manager;
      hostDir    = ../hosts/${host};
      hostCfg    = hostDir + "/configuration.nix";
      hostHome   = hostDir + "/home.nix";
      modules =
        [ hostCfg ]
        ++ (lib.optional darwinHost inputs."mac-app-util".darwinModules.default)
        ++ [
          hmModule {
            home-manager.useGlobalPkgs   = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.${username} = import hostHome;
          }
        ]
        ++ extraModules;
    in
      builder {
        inherit system modules;
        specialArgs = { inherit inputs username; } // extraArguments;
      };
}

