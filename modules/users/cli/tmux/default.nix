{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.nx.tmux;

in
{
  options.nx.tmux = {
    enable = mkOption {
      description = "tmux";
      type = types.bool;
      default = config.nx.terminal.multiplexer == "tmux";
    };
  };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      secureSocket = true;
      shell = "${pkgs.${config.nx.terminal.defaultShell}}/bin/${config.nx.terminal.defaultShell}";
      terminal = "xterm-256color";
      extraConfig = ''
        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # style
        set -g status-position top
        set -g status-justify absolute-centre
        set -g status-style 'fg=color7 bg=default'
        set -g status-right ""
        # set -g status-right ' #(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)'
        # set -g status-right ""
        set -g status-left '#S'
        set -g status-left-style 'fg=color8'
        set -g status-right-length 0
        set -g status-left-length 100
        setw -g window-status-current-style 'fg=colour6 bg=default bold'
        setw -g window-status-current-format '#I:#W '
        setw -g window-status-style 'fg=color8'

        set -g mouse on
      '';
    };
  };
}
