{ ... }:
{
  flake.modules.homeManager.mcp =
    { pkgs, inputs, ... }:
    let
      packages = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};

      inherit (packages)
        ffdecmcp
        ida-pro-mcp
        renderdoc-mcp
        ;
    in
    {
      home = {
        packages = [
          ffdecmcp
          ida-pro-mcp
          renderdoc-mcp
        ];

        file.".idapro/plugins/ida_mcp".source = "${ida-pro-mcp.idaPlugin}/ida_mcp";
        file.".idapro/plugins/ida_mcp.py".source = "${ida-pro-mcp.idaPlugin}/ida_mcp.py";
      };

      programs.mcp = {
        enable = true;

        servers = {
          ida-pro-mcp.url = "http://127.0.0.1:13337/mcp";

          ffdecmcp.command = pkgs.lib.getExe ffdecmcp;

          renderdoc.command = pkgs.lib.getExe renderdoc-mcp;
        };
      };
    };
}
