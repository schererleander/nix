{ inputs, ... }:
{
  flake.nixosConfigurations."adam" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with inputs.self.modules.nixos; [
      {
        nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlays.default ];
      }
      adam
      home-manager
      plymouth
      kde
      sway
      dns
      bluetooth
      mullvad-vpn
      steam
      wooting
    ];
  };
}
