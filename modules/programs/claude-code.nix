{
  flake.modules.homeManager.claude-code = {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;
    };
  };
}
