{
  fetchFromGitHub,
  ida-pro,
  lib,
  runCommand,
  writableTmpDirAsHomeHook,
}:
let
  inherit (ida-pro) python;
  pythonPackages = python.pkgs;

  pythonPackagesEnvironment = python.withPackages (ps: [
    ps.ida-nexus
    ps.zeromcp
    ps.rpyc
    ps.pip
  ]);

  # IDAPython selects site-packages from pyvenv.cfg beside the configured
  # interpreter; a withPackages launcher alone is not a virtual environment.
  pythonEnvironment = runCommand "ida-python-environment-${python.version}" { } ''
    ${python}/bin/python3 -m venv --without-pip "$out"
    rmdir "$out/${python.sitePackages}"
    ln -s "${pythonPackagesEnvironment}/${python.sitePackages}" \
      "$out/${python.sitePackages}"

    ${python}/bin/python3 -S ${./check-python-environment.py} "$out/bin/python3"
  '';
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "ida-mcp";
  version = "20261028.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HexRaysSA";
    repo = "ida-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AoCC/MFOsXXbIK0wqe25cnKYVV/Z9g5uKHnZqlL/RPY=";
  };

  build-system = [ pythonPackages.hatchling ];

  dependencies = [
    pythonPackages.ida-nexus
    pythonPackages.zeromcp
    pythonPackages.packaging
  ];

  # The MCP executable uses the IDA installation packaged here.
  makeWrapperArgs = [
    "--set"
    "IDADIR"
    "${ida-pro}/opt"
    "--set"
    "IDAPYTHON_VENV_EXECUTABLE"
    "${pythonEnvironment}/bin/python3"
  ];

  postInstall = ''
    install -Dm644 ida_mcp_plugin.py "$out/share/ida-mcp/ida_mcp_plugin.py"
    install -Dm644 ida-plugin.json "$out/share/ida-mcp/ida-plugin.json"
  '';

  pythonImportsCheck = [
    "ida_mcp"
    "ida_mcp.mcp"
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru = {
    inherit pythonEnvironment;
    idaPlugin = "${finalAttrs.finalPackage}/share/ida-mcp";
  };

  meta = {
    description = "Official Hex-Rays IDA MCP server";
    homepage = "https://github.com/HexRaysSA/ida-mcp";
    license = lib.licenses.mit;
    mainProgram = "ida-mcp";
    platforms = [ "x86_64-linux" ];
  };
})
