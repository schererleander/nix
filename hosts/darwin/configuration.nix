{ config, pkgs, lib, ...}:

{
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  users.users.schererleander = {
    home = "/Users/schererleander";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    taps = [];
    brews = [];
    casks = [
      "nextcloud"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;
}
