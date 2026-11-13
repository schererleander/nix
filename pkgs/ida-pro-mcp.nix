{
  fetchFromGitHub,
  fetchPypi,
  ida-pro,
  lib,
  python313,
  runCommand,
}:
let
  python = python313;
  pythonPackages = python.pkgs;

  idapro = pythonPackages.buildPythonPackage (finalAttrs: {
    pname = "idapro";
    version = "0.0.10";
    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      sha256 = "417c03c4605d18417e470f6a748e397b39d6d5829ebd3bbdedd92ff5b9092d11";
    };

    build-system = [ pythonPackages.setuptools ];
    doCheck = false;

    meta = {
      description = "IDA Library Python module";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  });

  idaDomain = pythonPackages.buildPythonPackage (finalAttrs: {
    pname = "ida-domain";
    version = "0.5.1";
    pyproject = true;

    src = fetchPypi {
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
      license = lib.licenses.mit;
    };
  });

  idaNexus = pythonPackages.buildPythonPackage (finalAttrs: {
    pname = "ida-nexus";
    version = "0.13.2";
    pyproject = true;

    src = fetchPypi {
      pname = "ida_nexus";
      inherit (finalAttrs) version;
      sha256 = "e50edb9a764aa104c087fe6211302400166274a1dcddaf904afc63054a5b9876";
    };

    build-system = [ pythonPackages.hatchling ];
    dependencies = [ idaDomain ];

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
      license = lib.licenses.mit;
      mainProgram = "ida-nexus";
    };
  });

  zeromcp = pythonPackages.buildPythonPackage (finalAttrs: {
    pname = "zeromcp";
    version = "1.10.3";
    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      sha256 = "71231db2d132e3e02e3b10ae1cb48849aff6ef5abbde07ffd23d1071acacbae6";
    };

    build-system = [ pythonPackages.hatchling ];
    pythonImportsCheck = [ "zeromcp" ];
    doCheck = false;

    meta = {
      description = "Python MCP server implementation";
      homepage = "https://github.com/mrexodia/zeromcp";
      license = lib.licenses.mit;
    };
  });

  pythonPackagesEnvironment = python.withPackages (ps: [
    idaNexus
    zeromcp
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

    ${python}/bin/python3 -S - "$out/bin/python3" <<'PY'
    import importlib.util
    import pathlib
    import sys

    sys.executable = sys.argv[1]
    import site
    site.main()

    assert pathlib.Path(sys.prefix) == pathlib.Path(sys.executable).parent.parent
    assert sys.prefix != sys.base_prefix
    for name in ("ida_nexus", "ida_domain", "rpyc", "pip"):
        assert importlib.util.find_spec(name) is not None, name
    import ida_nexus
    import rpyc
    PY
  '';
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "ida-mcp";
  version = "20260930.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HexRaysSA";
    repo = "ida-mcp";
    rev = "04f04828e44c6b8f7f7bb54718192dfafee19724";
    hash = "sha256-3nDJb2FMv5ddmGXVmUkudzuF9EyKKsx38fANoH9PkVo=";
  };

  build-system = [ pythonPackages.hatchling ];

  dependencies = [
    idaNexus
    zeromcp
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
    license = lib.licenses.mit;
    mainProgram = "ida-mcp";
    platforms = [ "x86_64-linux" ];
  };
})
