{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  archspec,
}:

buildPythonPackage (finalAttrs: {
  pname = "astc-encoder-py";
  version = "0.1.12";
  pyproject = true;

  src = fetchPypi {
    pname = "astc_encoder_py";
    inherit (finalAttrs) version;
    hash = "sha256-A3WawygEyuMrwjjnL5TFuifiKFB98AgWt0H3lh8RhPk=";
  };

  build-system = [
    setuptools
    archspec
  ];
  dependencies = [ archspec ];

  # Build all x86 variants, selected at runtime, instead of probing this CPU.
  env.CIBUILDWHEEL = "1";

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'setuptools<72.2.0' 'setuptools'
  '';

  pythonImportsCheck = [ "astc_encoder" ];

  meta = {
    description = "Python bindings for the ASTC texture encoder";
    homepage = "https://github.com/K0lb3/astc-encoder-py";
    license = lib.licenses.mit;
  };
})
