{
  lib,
  stdenvNoCC,
  callPackage,
}:
# Darwin installs the signed app bundle; Linux wraps the Debian package in an FHS environment.
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  meta = {
    description = "Official Claude desktop application";
    homepage = "https://claude.com/download";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "claude-desktop";
  };
}
