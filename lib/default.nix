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
      extraModules ? [ ],
      extraSpecialArgs ? { },
    }:
    let
      darwinHost = isDarwin system;
      builder = if darwinHost then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      hostDir = ../hosts/${host};
      hostCfg = hostDir + /configuration.nix;

      nixpkgsModule = {
        nixpkgs.overlays = overlays;
        nixpkgs.config.allowUnfree = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      };

      modules = [
        hostCfg
        nixpkgsModule
        (if darwinHost then inputs.home-manager.darwinModules.home-manager else inputs.home-manager.nixosModules.home-manager)
      ]
      ++ lib.optionals darwinHost [ inputs.mac-app-util.darwinModules.default ]
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
