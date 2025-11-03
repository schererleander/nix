{
  config,
  username,
  pkgs,
  lib,
  ...
}:

let
  pinentryPackage = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
  pinentryProgram = if pkgs.stdenv.isDarwin then "pinentry-mac" else "pinentry-curses";
in
{
  options.nx.programs.gpg.enable = lib.mkEnableOption "Setup gpg and agent" // {
    default = true;
  };
  config = lib.mkIf config.nx.programs.gpg.enable {
    home-manager.users.${username} = {
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        pinentry.package = pinentryPackage;
        pinentry.program = pinentryProgram;
      };
    };
  };
}
