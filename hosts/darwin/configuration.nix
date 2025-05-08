{ config, pkgs, lib, ...}:

{
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;


  users.users.schererleander = {
    home = "/Users/schererleander";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

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

  system.stateVersion = 5;
}
