{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      python = pkgs.python313;
      pythonPackages = python.pkgs;

      idapro = pythonPackages.buildPythonPackage (finalAttrs: {
        pname = "idapro";
        version = "0.0.9";

        pyproject = true;

        src = pkgs.fetchPypi {
          inherit (finalAttrs) pname version;
          hash = "sha256-igQ6ic5QdTPlAuj2WBpPtYut4l6PpgSVRbeexjZ5LjU=";
        };

        build-system = [
          pythonPackages.setuptools
        ];

        doCheck = false;

        meta = {
          description = "IDA Library Python module";
          license = pkgs.lib.licenses.mit;
          platforms = pkgs.lib.platforms.all;
        };
      });
    in
    {
      packages.ida-pro-mcp =
        pythonPackages.buildPythonApplication (finalAttrs: {
          pname = "ida-pro-mcp";
          version = "2.0.0";

          pyproject = true;

          src = pkgs.fetchFromGitHub {
            owner = "mrexodia";
            repo = "ida-pro-mcp";
            rev = "8a0820cf29a90ed82dbafd7f63b3bdac8722741c";
            hash = "sha256-Cm1xognadqF7/aUx5rmulc/nXUX3LPMJFhwfapaiQ0A=";
          };

          build-system = [
            pythonPackages.setuptools
          ];

          dependencies = [
            idapro
            pythonPackages.tomli-w
          ];

          pythonImportsCheck = [
            "ida_pro_mcp"
          ];

          doCheck = false;

          passthru.idaPlugin = "${finalAttrs.finalPackage}/${python.sitePackages}/ida_pro_mcp";

          meta = {
            description = "IDA Pro MCP server";
            homepage = "https://github.com/mrexodia/ida-pro-mcp";
            license = pkgs.lib.licenses.mit;
            mainProgram = "ida-pro-mcp";
            platforms = pkgs.lib.platforms.all;
          };
        });
    };
}
