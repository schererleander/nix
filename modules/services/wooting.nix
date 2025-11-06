{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nx.services.wooting.enable = lib.mkEnableOption "Wootility service";
  config = lib.mkIf config.nx.services.wooting.enable {
    services.udev.packages = [ pkgs.wooting-udev-rules ];
    environment.systemPackages = with pkgs; [
      wootility
    ];
  };
}
