{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  mcp,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "zeromcp";
  version = "1.10.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-cSMdstEy4+AuOxCuHLSISa/271q73gf/0j0QcaysuuY=";
  };

  build-system = [ hatchling ];
  pythonImportsCheck = [ "zeromcp" ];
  nativeCheckInputs = [
    pytestCheckHook
    mcp
    requests
  ];

  meta = {
    description = "Python MCP server implementation";
    homepage = "https://github.com/mrexodia/zeromcp";
    license = lib.licenses.mit;
  };
})
