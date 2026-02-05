{
  flake.modules.nixos.wooting =
    {
      pkgs,
      ...
    }:
    {
      services.udev.packages = [ pkgs.wooting-udev-rules ];
      environment.systemPackages = [ pkgs.wootility ];
    };
}
