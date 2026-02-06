{ inputs, ... }:
{
  flake.nixosConfigurations."adam" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with inputs.self.modules.nixos; [
      adam
      home-manager
      plymouth
      kde
      dns
      bluetooth
      mullvad-vpn
    ];
  };
}
