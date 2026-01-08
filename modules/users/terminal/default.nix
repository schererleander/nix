{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.nx.terminal;
in
{
  imports = [
    ./foot.nix
    ./kitty.nix
  ];
  options.nx.terminal = {
    font = mkOption {
      description = "default font";
      default = "Victor Mono";
    };

    multiplexer = mkOption {
      type = types.enum [ "tmux" ];
      default = "tmux";
    };

    defaultShell = mkOption {
      description = "default shell";
      type = types.enum [
        "bash"
        "zsh"
      ];
      default = "bash";
    };
  };
}
