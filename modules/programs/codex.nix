{
  flake.modules.homeManager.codex =
    { ... }:
    {
      programs.codex = {
        enable = true;
        enableMcpIntegration = false;
      };
    };
}
