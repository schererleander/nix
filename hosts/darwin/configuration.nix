{ config, pkgs, lib, ...}:

{
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  users.users.schererleander = {
    home = "/Users/schererleander";
    shell = pkgs.zsh;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;
}
