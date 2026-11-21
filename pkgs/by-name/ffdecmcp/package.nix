{
  lib,
  python3Packages,
  fetchPypi,
  writableTmpDirAsHomeHook,
  jre,
  jpexs,
}:
let
  jar = "${jpexs}/share/ffdec/ffdec.jar";
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ffdecmcp";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-M4TQ9wNUWOstLZjQVdh1gmWg1zJvvcDIpcpIWjC8FBc=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.fastmcp
    python3Packages.python-dotenv
  ];

  postPatch = ''
    # FastMCP 3 leaves decorated tools as ordinary callable functions.
    substituteInPlace tests/test_tools.py --replace-fail '.fn(' '('
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ jre ])
    "--set"
    "FFDEC_JAR_PATH"
    jar
  ];

  pythonImportsCheck = [ "ffdecmcp" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];
  env.FFDEC_JAR_PATH = jar;

  meta = {
    description = "MCP wrapper for JPEXS Free Flash Decompiler";
    homepage = "https://github.com/sublimnl/ffdecmcp";
    license = lib.licenses.mit;
    mainProgram = "ffdecmcp";
    platforms = lib.platforms.unix;
  };
})
