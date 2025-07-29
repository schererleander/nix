{ pkgs, lib, ... }: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./tmux.nix
    ./zathura.nix
    ./vscode.nix
    ./gpg.nix
  ];
}
