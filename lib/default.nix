{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
  isDarwin = s: lib.strings.hasSuffix "-darwin" s;
in
{
  mkSystem =
    {
      host,
      username,
      system,
      overlays ? [ ],
      sharedModules ? [ ],
      extraModules ? [ ],
      extraArguments ? { },
    }:
    let
      darwinHost = isDarwin system;
      builder = if darwinHost then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      hmModule =
        if darwinHost then
          inputs.home-manager.darwinModules.home-manager
        else
          inputs.home-manager.nixosModules.home-manager;
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      hostDir = ../hosts/${host};
      hostCfg = hostDir + /configuration.nix;
      hostHome = hostDir + /home.nix;

      hmEnabled = builtins.pathExists hostHome;
      modules = [
        hostCfg
      ]
      ++ lib.optionals darwinHost [ inputs.mac-app-util.darwinModules.default ]
      ++ [
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          nixpkgs.overlays = overlays;
        }
      ]
      ++ lib.optionals hmEnabled [
        hmModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs pkgs; };
          home-manager.users.${username} = import hostHome;
          home-manager.sharedModules = sharedModules;
        }
      ]
      ++ extraModules;
    in
    builder {
      system = system;
      specialArgs = {
        inherit inputs pkgs;
      }
      // extraArguments;
      modules = modules;
    };
}
