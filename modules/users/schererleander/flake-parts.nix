{ inputs, withSystem, ... }:
{
  flake.homeConfigurations = {
    # NixOS configuration for adam workstation
    "schererleander@adam" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
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
      pkgs = withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs);
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
