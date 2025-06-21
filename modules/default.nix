{ pkgs, lib, ... }: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./foot.nix
    ./sway.nix
    ./tmux.nix
    ./emacs.nix
    ./waybar.nix
    ./nextcloud.nix
    ./spicetify.nix
    ./zathura.nix
    ./vscode.nix
    ./chromium.nix
    ./nixcord.nix
    ./wezterm.nix
    ./firefox.nix
    ./nvf.nix
    ./aerospace.nix
    ./dunst.nix
    ./gpg.nix
  ];
}
