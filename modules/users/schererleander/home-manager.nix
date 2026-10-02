{ inputs, ... }:
let
  homeManager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };
in
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = homeManager // {
      users.schererleander = inputs.self.modules.homeManager.schererleander-linux;
    };
  };

  flake.modules.darwin.home-manager = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home-manager = homeManager // {
      users.schererleander = inputs.self.modules.homeManager.schererleander-darwin;
    };
  };
}
