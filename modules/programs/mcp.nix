{ ... }:
{
  flake.modules.homeManager.mcp =
    { pkgs, ... }:
    let
      idaPython = "${pkgs.ida-mcp.pythonEnvironment}/bin/python3";
    in
    {
      home = {
        packages = with pkgs; [
          ffdecmcp
          ida-mcp
          renderdoc-mcp
        ];

        file.".idapro/plugins/ida-mcp".source = pkgs.ida-mcp.idaPlugin;
        sessionVariables.IDAPYTHON_VENV_EXECUTABLE = idaPython;
      };

      xdg.configFile."environment.d/50-hexrays-idapython.conf".text = ''
        IDAPYTHON_VENV_EXECUTABLE=${idaPython}
      '';

      programs.mcp = {
        enable = true;

        servers = {
          ida-pro-mcp = {
            command = pkgs.lib.getExe pkgs.ida-mcp;
            args = [ "stdio" ];
          };

          ffdecmcp.command = pkgs.lib.getExe pkgs.ffdecmcp;

          renderdoc.command = pkgs.lib.getExe pkgs.renderdoc-mcp;
        };
      };
    };
}
