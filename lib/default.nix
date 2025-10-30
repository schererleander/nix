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
      extraSpecialArgs ? { },
    }:
    let
      darwinHost = isDarwin system;
      builder = if darwinHost then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      hmModule =
        if darwinHost then
          inputs.home-manager.darwinModules.home-manager
        else
          inputs.home-manager.nixosModules.home-manager;
      hostDir = ../hosts/${host};
      hostCfg = hostDir + /configuration.nix;
      hostHome = hostDir + /home.nix;

      hmEnabled = builtins.pathExists hostHome;

      nixpkgsModule = {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
        nixpkgs.overlays = overlays;
        nixpkgs.config.allowUnfree = true;
      };

      modules = [
        hostCfg
        nixpkgsModule
      ]
      ++ lib.optionals darwinHost [ inputs.mac-app-util.darwinModules.default ]
      ++ lib.optionals hmEnabled [
        hmModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              system
              host
              username
              ;
          }
          // extraSpecialArgs;
          home-manager.users.${username} = import hostHome;
          home-manager.sharedModules =
            sharedModules ++ lib.optional darwinHost inputs.mac-app-util.homeManagerModules.default;
        }
      ]
      ++ extraModules;
    in
    builder {
      system = system;
      specialArgs = (
        {
          inherit
            inputs
            system
            host
            username
            ;
        }
        // extraSpecialArgs
      );
      modules = modules;
    };
}
