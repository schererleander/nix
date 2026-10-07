{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      python = pkgs.python313;
      pythonPackages = python.pkgs;

      idapro = pythonPackages.buildPythonPackage (finalAttrs: {
        pname = "idapro";
        version = "0.0.10";

        pyproject = true;

        src = pkgs.fetchPypi {
          inherit (finalAttrs) pname version;
          sha256 = "417c03c4605d18417e470f6a748e397b39d6d5829ebd3bbdedd92ff5b9092d11";
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

      idaDomain = pythonPackages.buildPythonPackage (finalAttrs: {
        pname = "ida-domain";
        version = "0.5.1";
        pyproject = true;

        src = pkgs.fetchPypi {
          pname = "ida_domain";
          inherit (finalAttrs) version;
          sha256 = "c49f2c417047d882e954f651b50a709a3f27903b33ba533b794aa54d6536d16f";
        };

        build-system = [ pythonPackages.hatchling ];
        dependencies = [
          idapro
          pythonPackages.packaging
          pythonPackages.typing-extensions
        ];

        # Importing ida_domain initializes the licensed IDA runtime.
        doCheck = false;

        meta = {
          description = "Hex-Rays IDA Domain Python API";
          homepage = "https://github.com/HexRaysSA/ida-domain";
          license = pkgs.lib.licenses.mit;
        };
      });

      idaNexus = pythonPackages.buildPythonPackage (finalAttrs: {
        pname = "ida-nexus";
        version = "0.13.2";
        pyproject = true;

        src = pkgs.fetchPypi {
          pname = "ida_nexus";
          inherit (finalAttrs) version;
          sha256 = "e50edb9a764aa104c087fe6211302400166274a1dcddaf904afc63054a5b9876";
        };

        build-system = [ pythonPackages.hatchling ];
        dependencies = [ idaDomain ];

        # Embedded IDAPython has a different prefix from the worker interpreter.
        postPatch = ''
          substituteInPlace ida_nexus/paths.py \
            --replace-fail 'dirs: list[str] = []' \
              'dirs: list[str] = ["${placeholder "out"}/bin"]'
        '';

        pythonImportsCheck = [ "ida_nexus" ];
        doCheck = false;

        meta = {
          description = "Hex-Rays IDA database session manager";
          homepage = "https://github.com/HexRaysSA/ida-nexus";
          license = pkgs.lib.licenses.mit;
          mainProgram = "ida-nexus";
        };
      });

      zeromcp = pythonPackages.buildPythonPackage (finalAttrs: {
        pname = "zeromcp";
        version = "1.10.3";
        pyproject = true;

        src = pkgs.fetchPypi {
          inherit (finalAttrs) pname version;
          sha256 = "71231db2d132e3e02e3b10ae1cb48849aff6ef5abbde07ffd23d1071acacbae6";
        };

        build-system = [ pythonPackages.hatchling ];
        pythonImportsCheck = [ "zeromcp" ];
        doCheck = false;

        meta = {
          description = "Python MCP server implementation";
          homepage = "https://github.com/mrexodia/zeromcp";
          license = pkgs.lib.licenses.mit;
        };
      });

      pythonEnvironment = python.withPackages (ps: [
        idaNexus
        zeromcp
        ps.rpyc
      ]);
    in
    {
      packages.ida-pro-mcp = pythonPackages.buildPythonApplication (finalAttrs: {
        pname = "ida-mcp";
        version = "20260930.0.1";

        pyproject = true;

        src = pkgs.fetchFromGitHub {
          owner = "HexRaysSA";
          repo = "ida-mcp";
          rev = "04f04828e44c6b8f7f7bb54718192dfafee19724";
          hash = "sha256-3nDJb2FMv5ddmGXVmUkudzuF9EyKKsx38fANoH9PkVo=";
        };

        build-system = [
          pythonPackages.hatchling
        ];

        dependencies = [
          idaNexus
          zeromcp
          pythonPackages.packaging
        ];

        postInstall = ''
          install -Dm644 ida_mcp_plugin.py "$out/share/ida-mcp/ida_mcp_plugin.py"
          install -Dm644 ida-plugin.json "$out/share/ida-mcp/ida-plugin.json"
        '';

        pythonImportsCheck = [
          "ida_mcp"
          "ida_mcp.mcp"
        ];

        nativeCheckInputs = [ pythonPackages.pytestCheckHook ];
        preCheck = ''
          export HOME="$TMPDIR/ida-mcp-home"
          mkdir -p "$HOME"
        '';

        passthru = {
          inherit pythonEnvironment;
          idaPlugin = "${finalAttrs.finalPackage}/share/ida-mcp";
        };

        meta = {
          description = "Official Hex-Rays IDA MCP server";
          homepage = "https://github.com/HexRaysSA/ida-mcp";
          license = pkgs.lib.licenses.mit;
          mainProgram = "ida-mcp";
          platforms = pkgs.lib.platforms.all;
        };
      });
    };
}
