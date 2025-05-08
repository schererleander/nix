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
    brews = [
      "openjdk@17"
      "openjdk@21"
    ];
    casks = [
      "nextcloud"
      "bambu-studio"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;
}
