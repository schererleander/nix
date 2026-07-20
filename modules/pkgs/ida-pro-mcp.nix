{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      idapro = pkgs.python313.pkgs.buildPythonPackage rec {
        pname = "idapro";
        version = "0.0.9";

        pyproject = true;

        src = pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-igQ6ic5QdTPlAuj2WBpPtYut4l6PpgSVRbeexjZ5LjU=";
        };

        build-system = [
          pkgs.python313.pkgs.setuptools
        ];

        doCheck = false;

        meta = with pkgs.lib; {
          description = "IDA Library Python module";
          license = licenses.mit;
          platforms = platforms.all;
        };
      };
    in
    {
      packages.ida-pro-mcp = pkgs.python313.pkgs.buildPythonApplication rec {
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
          pkgs.python313.pkgs.setuptools
        ];

        dependencies = [
          idapro
          pkgs.python313.pkgs.tomli-w
        ];

        pythonImportsCheck = [
          "ida_pro_mcp"
        ];

        doCheck = false;

        meta = with pkgs.lib; {
          description = "IDA Pro MCP server";
          homepage = "https://github.com/mrexodia/ida-pro-mcp";
          license = licenses.mit;
          mainProgram = "ida-pro-mcp";
          platforms = platforms.all;
        };
      };
    };
}
