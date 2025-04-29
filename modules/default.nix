{ pkgs, lib, ... }: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./foot.nix
    ./sway.nix
    ./tmux.nix
    ./emacs.nix
    ./waybar.nix
    ./neovim/default.nix
    ./nextcloud.nix
    ./spicetify.nix
  ];
}
