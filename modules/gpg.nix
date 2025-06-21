{ config, pkgs, lib, ...}:

{
  options.gpg.enable = lib.mkEnableOption "Setup gpg and agent";
  config = lib.mkIf config.gpg.enable {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
    };
  };
}
