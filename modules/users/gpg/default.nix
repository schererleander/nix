{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.nx.gpg;
in
{

  options.nx.gpg = {
    enable = mkOption {
      description = "GNU Privacy Guard";
      type = types.bool;
      default = config.nx.git.enable;
    };

    gpgKey = mkOption {
      description = "default gpg key";
      type = types.nullOr types.str;
      default = "";
    };

    pinentry = mkOption {
      description = "pinentry flavor";
      type = types.enum [
        "curses"
        "gnome3"
        "qt"
        "mac"
      ];
      default = if pkgs.stdenv.isDarwin then "mac" else "curses";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      #settings.default-key = mkIf (cfg.gpgKey != null) cfg.gpgKey;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package =
        if cfg.pinentry == "gnome3" then
          pkgs.pinentry-gnome3
        else if cfg.pinentry == "qt" then
          pkgs.pinentry-qt
        else if cfg.pinentry == "mac" then
          pkgs.pinentry_mac
        else
          pkgs.pinentry-curses;
    };
  };
}
