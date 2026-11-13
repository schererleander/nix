{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "claude-desktop";
  version = "4.16336.0";

  src = fetchurl {
    url = "https://downloads.claude.ai/releases/darwin/universal/4.16336.0/Claude-61c5bb50afdeb36ef1152e82f33cdb2f46fccdee.zip";
    hash = "sha256-N0DAW0uCRW5L1g7p+v8Tx2QPEBp2g3Fbl3MzsoPw7s0=";
  };

  nativeBuildInputs = [ unzip ];

  # Preserve the bundled native modules and runtime resources.
  dontStrip = true;
  dontBuild = true;
  sourceRoot = ".";
  dontFixup = true;

  unpackPhase = ''
    runHook preUnpack
    unzip -q "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications" "$out/bin"
    cp -a Claude.app "$out/Applications/"
    ln -s "$out/Applications/Claude.app/Contents/MacOS/Claude" "$out/bin/claude-desktop"
    runHook postInstall
  '';

  meta = {
    description = "Official Claude desktop application";
    homepage = "https://claude.com/download";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "claude-desktop";
  };
}
