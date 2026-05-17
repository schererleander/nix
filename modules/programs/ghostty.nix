{
  flake.modules.homeManager.ghostty =
    { ... }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          font-family = "JetBrains Mono";
          font-size = 13;
          font-thicken = true;
          theme = "Gruvbox Dark";
          background = "#000000";
          window-decoration = false;
          copy-on-select = "clipboard";
        };
      };
    };
}
