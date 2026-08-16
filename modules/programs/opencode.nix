{
  flake.modules.homeManager.opencode =
    { inputs, ... }:
    {
      imports = [
        inputs.self.modules.homeManager.mcp
      ];

      programs.opencode = {
        enable = true;
        enableMcpIntegration = true;
      };
    };
}
