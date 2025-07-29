{ config, lib, pkgs, ... }:

{
  options.tmux.enable = lib.mkEnableOption "Enable and configure Tmux";
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
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
