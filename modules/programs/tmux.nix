{
  flake.modules.homeManager.tmux = {
    programs.tmux = {
      enable = true;
      mouse = true;
      historyLimit = 10000;
      baseIndex = 1;
      keyMode = "emacs";
      extraConfig = ''
        set -g renumber-windows on
      '';
    };
  };
}
