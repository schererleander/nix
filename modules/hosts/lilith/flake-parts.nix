{
  inputs,
  ...
}:

{
  flake.darwinConfigurations.lilith = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    system = "aarch64-darwin";
    modules = [
      inputs.self.modules.darwin.lilith
      inputs.self.modules.darwin.dns
      inputs.self.modules.darwin.home-manager
    ];
  };
}
