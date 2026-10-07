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

        file.".idapro/plugins/ida-mcp".source = ida-pro-mcp.idaPlugin;
      };

      programs.mcp = {
        enable = true;

        servers = {
          ida-pro-mcp = {
            command = pkgs.lib.getExe ida-pro-mcp;
            args = [ "stdio" ];
            env.IDADIR = "${packages.ida-pro}/opt";
          };

          ffdecmcp.command = pkgs.lib.getExe ffdecmcp;

          renderdoc.command = pkgs.lib.getExe renderdoc-mcp;
        };
      };
    };
}
