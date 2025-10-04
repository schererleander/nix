{
  config,
  pkgs,
  lib,
  ...
}:

let
  pinentryPackage = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
  pinentryProgram = if pkgs.stdenv.isDarwin then "pinentry-mac" else "pinentry-curses";
in
{
  options.gpg.enable = lib.mkEnableOption "Setup gpg and agent";
  config = lib.mkIf config.gpg.enable {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentry.package = pinentryPackage;
      pinentry.program = pinentryProgram;
    };
  };
}
