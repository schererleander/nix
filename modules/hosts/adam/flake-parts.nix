{ inputs, ... }:
{
  flake.nixosConfigurations."adam" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = with inputs.self.modules.nixos; [
      inputs.self.modules.nixos.nixpkgs
      inputs.lanzaboote.nixosModules.lanzaboote
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
