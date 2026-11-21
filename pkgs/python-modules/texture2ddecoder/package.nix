{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "texture2ddecoder";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-iPBNiVEBisE7jazQflfora1Kbxz+VQlkbooQIDRqgco=";
  };

  build-system = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'setuptools<72.2.0' 'setuptools'
  '';

  pythonImportsCheck = [ "texture2ddecoder" ];

  meta = {
    description = "Python bindings for decoding texture formats";
    homepage = "https://github.com/K0lb3/texture2ddecoder";
    license = lib.licenses.mit;
  };
})
