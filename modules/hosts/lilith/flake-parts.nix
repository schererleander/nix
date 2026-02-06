{
  inputs,
  ...
}:

{
  flake.darwinConfigurations.lilith = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; };
    system = "aarch64-darwin";
    modules = with inputs.self.modules.darwin; [
      lilith
      dns
      home-manager
    ];
  };
}
