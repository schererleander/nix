{
  lib,
  fetchFromGitHub,
  renderdoc,
  python312Packages,
  vulkan-loader,
}:
let
  pythonPackages = python312Packages;

  # Stable RenderDoc builds bindings for Python 3.12, but does not install them.
  # The server must run on the interpreter that built the extension module.
  renderdocWithPython = (renderdoc.override { inherit python312Packages; }).overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      install -Dm755 lib/renderdoc.so $out/lib/renderdoc.so
    '';
  });
in
pythonPackages.buildPythonApplication {
  pname = "renderdoc-mcp";
  version = "0.2.0-unstable-2026-03-05";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Linkingooo";
    repo = "renderdoc-mcp";
    rev = "4911c47b78df2a5b2967a98bef827e7ccda6cac4";
    hash = "sha256-JRcSnU7k5QsNF8l8XpO8Y6QlLfqPiBayQGg13nVSI8w=";
  };

  build-system = [ pythonPackages.hatchling ];

  dependencies = [ pythonPackages.mcp ];

  patches = [ ./accurate-buffer-inspection.patch ];

  makeWrapperArgs = [
    "--set"
    "RENDERDOC_MODULE_PATH"
    "${renderdocWithPython}/lib"
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [
      renderdocWithPython
      vulkan-loader
    ])
  ];

  env.RENDERDOC_MODULE_PATH = "${renderdocWithPython}/lib";
  nativeCheckInputs = [ pythonPackages.unittestCheckHook ];
  unittestFlags = [
    "-s"
    "tests"
  ];
  pythonImportsCheck = [
    "renderdoc_mcp"
    "renderdoc_mcp.server"
  ];

  passthru.renderdoc = renderdocWithPython;

  meta = {
    description = "MCP server for RenderDoc GPU frame capture analysis";
    homepage = "https://github.com/Linkingooo/renderdoc-mcp";
    license = lib.licenses.mit;
    mainProgram = "renderdoc-mcp";
    platforms = lib.platforms.linux;
  };
}
