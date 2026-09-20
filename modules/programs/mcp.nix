{
  flake.modules.homeManager.mcp =
    { pkgs, inputs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      ida-pro-mcp = inputs.self.packages.${system}.ida-pro-mcp;
      ffdecmcp = inputs.self.packages.${system}.ffdecmcp;
      pluginRoot = "${ida-pro-mcp}/${pkgs.python313.sitePackages}/ida_pro_mcp";
    in
    {
      home = {
        packages = [
          ida-pro-mcp
          ffdecmcp
        ];
        file = {
          ".idapro/plugins/ida_mcp.py".source = "${pluginRoot}/ida_mcp.py";
          ".idapro/plugins/ida_mcp".source = "${pluginRoot}/ida_mcp";
        };
      };

      programs.mcp = {
        enable = true;
        servers = {
          "ida-pro-mcp" = {
            url = "http://127.0.0.1:13337/mcp";
          };

          ffdecmcp = {
            command = "${ffdecmcp}/bin/ffdecmcp";
          };
        };
      };
    };
}
