{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  ida-domain,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ida-nexus";
  version = "0.14.2";
  pyproject = true;

  src = fetchPypi {
    pname = "ida_nexus";
    inherit (finalAttrs) version;
    hash = "sha256-k6ldYomIT9TO839WBUvROWbXinic14C+7CFmhFhheeY=";
  };

  build-system = [ hatchling ];
  dependencies = [ ida-domain ];

  postPatch = ''
    substituteInPlace ida_nexus/paths.py \
      --replace-fail 'dirs: list[str] = []' \
        'dirs: list[str] = ["${placeholder "out"}/bin"]'

    # The pinned test worker changes directories and needs its own import path.
    substituteInPlace tests/test_resolver_scenarios.py \
      --replace-fail 'environment = {"NEXUS_PINNED": "yes"}' \
        'environment = {"NEXUS_PINNED": "yes", "PYTHONPATH": str(Path(resolver.__file__).resolve().parents[1])}'
  '';

  pythonImportsCheck = [ "ida_nexus" ];
  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];
  # These tests load a licensed IDA; the remaining tests use mock backends.
  disabledTestMarks = [ "idalib_e2e" ];
  disabledTestPaths = [ "tests/test_suggest.py" ];
  # A 50 ms timing check and a spawned worker fail in the Darwin sandbox.
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_handle_keepalive_retains_idle_managed_worker"
    "test_launch_guard_preserves_worker_environment_and_directory_policy"
  ];

  meta = {
    description = "Hex-Rays IDA database session manager";
    homepage = "https://github.com/HexRaysSA/ida-nexus";
    license = lib.licenses.mit;
    mainProgram = "ida-nexus";
  };
})
