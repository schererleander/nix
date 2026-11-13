{
  python312,
  fetchFromGitHub,
  vulkan-loader,
  renderdoc-with-python,
  lib,
}:
let
  python = python312;
  pythonPackages = python.pkgs;
in
pythonPackages.buildPythonApplication {
  pname = "renderdoc-mcp";
  version = "0.2.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Linkingooo";
    repo = "renderdoc-mcp";
    rev = "4911c47b78df2a5b2967a98bef827e7ccda6cac4";
    hash = "sha256-JRcSnU7k5QsNF8l8XpO8Y6QlLfqPiBayQGg13nVSI8w=";
  };

  build-system = [
    pythonPackages.hatchling
  ];

  dependencies = [
    pythonPackages.mcp
  ];

  # Upstream drops constant-buffer ranges and rounds small float values to zero.
  postPatch = ''
    substituteInPlace src/renderdoc_mcp/tools/shader_tools.py \
      --replace-fail \
        'cbuffer_index, cb_bind.descriptor.resource, 0, 0,' \
        'cbuffer_index, cb_bind.descriptor.resource, cb_bind.descriptor.byteOffset, cb_bind.descriptor.byteSize,'

    substituteInPlace src/renderdoc_mcp/tools/pipeline_tools.py \
      --replace-fail \
        '"byte_size": cb_refl.byteSize,' \
        '"byte_size": cb_refl.byteSize, "byte_offset": cb_bind.descriptor.byteOffset, "bound_byte_size": cb_bind.descriptor.byteSize,'

    substituteInPlace src/renderdoc_mcp/tools/data_tools.py \
      --replace-fail \
        '[round(f, 6) for f in floats]' \
        'floats'
  '';

  makeWrapperArgs = [
    "--set"
    "RENDERDOC_MODULE_PATH"
    "${renderdoc-with-python}/lib"
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [
      renderdoc-with-python
      vulkan-loader
    ])
  ];

  env.RENDERDOC_MODULE_PATH = "${renderdoc-with-python}/lib";
  checkPhase = ''
    runHook preCheck
    PYTHONPATH="$PWD/src''${PYTHONPATH:+:$PYTHONPATH}" \
      ${python.interpreter} -B -m unittest discover -s tests
    runHook postCheck
  '';
  pythonImportsCheck = [
    "renderdoc_mcp"
    "renderdoc_mcp.server"
  ];

  meta = {
    description = "MCP server for RenderDoc GPU frame capture analysis";
    homepage = "https://github.com/Linkingooo/renderdoc-mcp";
    license = lib.licenses.mit;
    mainProgram = "renderdoc-mcp";
    platforms = lib.platforms.linux;
  };
}
