{ ... }:
{
  flake.overlays.ida-pro-mcp = final: prev: {
    idapro = final.python313.pkgs.buildPythonPackage rec {
      pname = "idapro";
      version = "0.0.9";

      pyproject = true;

      src = final.fetchPypi {
        inherit pname version;
        hash = "sha256-igQ6ic5QdTPlAuj2WBpPtYut4l6PpgSVRbeexjZ5LjU=";
      };

      build-system = [
        final.python313.pkgs.setuptools
      ];

      doCheck = false;

      meta = with final.lib; {
        description = "IDA Library Python module";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };

    ida-pro-mcp = final.python313.pkgs.buildPythonApplication rec {
      pname = "ida-pro-mcp";
      version = "2.0.0";

      pyproject = true;

      src = final.fetchFromGitHub {
        owner = "mrexodia";
        repo = "ida-pro-mcp";
        rev = "main";
        hash = "sha256-NkZVtKj4zvUSdEpQxH+/2k2LZrqK322G64jSVAroHaE=";
      };

      build-system = [
        final.python313.pkgs.setuptools
      ];

      dependencies = [
        final.idapro
        final.python313.pkgs.tomli-w
      ];

      pythonImportsCheck = [
        "ida_pro_mcp"
      ];

      doCheck = false;

      meta = with final.lib; {
        description = "IDA Pro MCP server";
        homepage = "https://github.com/mrexodia/ida-pro-mcp";
        license = licenses.mit;
        mainProgram = "ida-pro-mcp";
        platforms = platforms.all;
      };
    };
  };
}
