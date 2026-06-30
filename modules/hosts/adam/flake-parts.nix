{ inputs, ... }:
{
  flake.nixosConfigurations."adam" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with inputs.self.modules.nixos; [
      {
        nixpkgs.overlays = [
          inputs.self.overlays.ida-pro
          inputs.self.overlays.ida-pro-mcp
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
