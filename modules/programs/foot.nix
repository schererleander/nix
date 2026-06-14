{
  flake.modules.homeManager.foot =
    { ... }:
    {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "JetBrains Mono:size=11";
            dpi-aware = "yes";
          };
          colors = {
            alpha = 0.9;
            background = "000000";
            foreground = "ffffff";
          };
        };
      };
    };
}
