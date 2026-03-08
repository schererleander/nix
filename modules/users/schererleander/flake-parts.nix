{ inputs, ... }:
{
  flake.homeConfigurations = {
    # NixOS configuration for adam workstation
    "schererleander@adam" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        inputs.self.modules.homeManager.schererleander-linux
        {
          home.homeDirectory = "/home/schererleander";
        }
      ];
    };

    # Darwin configuration for lilith laptop
    "schererleander@lilith" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        inputs.self.modules.homeManager.schererleander-darwin
        {
          home.homeDirectory = "/Users/schererleander";
        }
      ];
    };
  };
}
