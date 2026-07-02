{
  flake.modules.homeManager.mcp =
    { pkgs, inputs, ... }:
    let
      ida-pro-mcp = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.ida-pro-mcp;
      pluginRoot = "${ida-pro-mcp}/${pkgs.python313.sitePackages}/ida_pro_mcp";
    in
    {
      home = {
        packages = [ ida-pro-mcp ];
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
        };
      };
    };
}
