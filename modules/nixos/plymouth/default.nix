{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.plymouth;
in
{
  options.nx.plymouth.enable = mkEnableOption "Plymouth";

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      consoleLogLevel = 3;
      loader.systemd-boot.consoleMode = "max";
      plymouth = {
        enable = true;
        theme = "lone";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "lone" ];
          })
        ];
      };
    };
  };
}
