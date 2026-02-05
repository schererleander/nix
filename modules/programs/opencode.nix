{
  flake.modules.homeManager.opencode =
    { ... }:
    {
      programs.opencode = {
        enable = true;
        settings = {
          theme = "system";
          share = "disabled";
          autoupdate = false;
        };
      };
    };
}
