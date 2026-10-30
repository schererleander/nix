{ ... }:
{
  flake.modules.homeManager.mcp =
    { pkgs, inputs, ... }:
    let
      packages = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};

      inherit (packages)
        ffdecmcp
        renderdoc-mcp
        ;
    in
    {
      home = {
        packages = [
          ffdecmcp
          pkgs.ida-pro-mcp
          renderdoc-mcp
        ];

        file.".idapro/plugins/ida-mcp".source = pkgs.ida-pro-mcp.idaPlugin;
      };

      programs.mcp = {
        enable = true;

        servers = {
          ida-pro-mcp = {
            command = pkgs.lib.getExe pkgs.ida-pro-mcp;
            args = [ "stdio" ];
          };

          ffdecmcp.command = pkgs.lib.getExe ffdecmcp;

          renderdoc.command = pkgs.lib.getExe renderdoc-mcp;
        };
      };
    };
}
