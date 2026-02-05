{ inputs, ... }:
{
  flake.nixosConfigurations."adam" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      inputs.self.modules.nixos.adam
      inputs.self.modules.nixos.secrets
      inputs.self.modules.nixos.home-manager
      inputs.self.modules.nixos.plymouth
      inputs.self.modules.nixos.kde
      inputs.self.modules.nixos.dns
      inputs.self.modules.nixos.bluetooth
    ];
  };
}
