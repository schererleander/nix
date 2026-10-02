{ inputs, withSystem, ... }:
{
  flake.homeConfigurations = {
    "schererleander@adam" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
      extraSpecialArgs = { inherit inputs; };
      modules = [ inputs.self.modules.homeManager.schererleander-linux ];
    };

    "schererleander@lilith" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs);
      extraSpecialArgs = { inherit inputs; };
      modules = [ inputs.self.modules.homeManager.schererleander-darwin ];
    };
  };
}
