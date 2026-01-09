{ inputs, config, self, ... }:

{
  flake.darwinConfigurations = {
    lilith = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; host = "lilith"; };
      modules = [
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [ config.flake.homeModules.default ];
        }
        (self + /hosts/lilith/configuration.nix)
        {
          nixpkgs.config.allowUnfree = true;
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
        }
      ];
    };
  };
}
