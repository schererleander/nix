{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      fastmcp = pkgs.python313.pkgs.fastmcp.overridePythonAttrs (old: {
        # Backport the proxy teardown test exclusions from newer nixpkgs:
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/python-modules/fastmcp/default.nix
        # RuntimeError: Attempted to exit a cancel scope that isn't the current task's current cancel scope.
        disabledTests = (old.disabledTests or [ ]) ++ [
          "test_stateful_proxy"
          "test_concurrent_log_requests_no_mixing"
          "test_multi_proxies_no_mixing"
        ];
      });
    in
    {
      packages.ffdecmcp = pkgs.python313.pkgs.buildPythonApplication rec {
        pname = "ffdecmcp";
        version = "0.1.2";

        pyproject = true;

        src = pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-M4TQ9wNUWOstLZjQVdh1gmWg1zJvvcDIpcpIWjC8FBc=";
        };

        build-system = [
          pkgs.python313.pkgs.setuptools
        ];

        dependencies = [
          fastmcp
          pkgs.python313.pkgs.python-dotenv
        ];

        nativeBuildInputs = [
          pkgs.makeWrapper
        ];

        postFixup = ''
          wrapProgram $out/bin/ffdecmcp \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jre ]}
        '';

        pythonImportsCheck = [
          "ffdecmcp"
        ];

        doCheck = false;

        meta = with pkgs.lib; {
          description = "MCP wrapper for JPEXS Free Flash Decompiler";
          homepage = "https://github.com/sublimnl/ffdecmcp";
          license = licenses.mit;
          mainProgram = "ffdecmcp";
          platforms = platforms.unix;
        };
      };
    };
}
