{
  config,
  pkgs,
  lib,
  system,
  ...
}:

let
  pinentryPackage = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
in
{
  options.gpg.enable = lib.mkEnableOption "Setup gpg and agent";
  config = lib.mkIf config.gpg.enable {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentry.package = pinentryPackage;
    };
  };
}
