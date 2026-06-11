{ inputs, ... }:
{
  flake.nixosConfigurations."adam" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with inputs.self.modules.nixos; [
      {
        nixpkgs.overlays = [
          inputs.nixpkgs-wayland.overlays.default
          inputs.self.overlays.ida-pro
          inputs.self.overlays.ida-pro-mcp
          inputs.self.overlays.fluffy-mod-manager
        ];
      }
      adam
      ida-pro
      home-manager
      plymouth
      localization
      kde
      dns
      audio
      font
      printer
      bluetooth
      wifi
      mullvad-vpn
      steam
      tailscale
      wooting
    ];
  };
}
