{
  flake.modules.nixos.mullvad-vpn =
    {
      pkgs,
      ...
    }:
    {
      services.mullvad-vpn.enable = true;
      environment.systemPackages = [ pkgs.mullvad-vpn ];
    };
}
