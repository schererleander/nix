{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  meta,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-desktop";
  version = "4.16336.0";

  src = fetchurl {
    url = "https://downloads.claude.ai/releases/darwin/universal/${finalAttrs.version}/Claude-61c5bb50afdeb36ef1152e82f33cdb2f46fccdee.zip";
    hash = "sha256-N0DAW0uCRW5L1g7p+v8Tx2QPEBp2g3Fbl3MzsoPw7s0=";
  };

  strictDeps = true;
  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  # Preserve the signed bundle and its Electron runtime.
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications" "$out/bin"
    cp -a Claude.app "$out/Applications/"
    ln -s "$out/Applications/Claude.app/Contents/MacOS/Claude" "$out/bin/claude-desktop"
    runHook postInstall
  '';

  meta = meta // {
    platforms = lib.platforms.darwin;
  };
})
