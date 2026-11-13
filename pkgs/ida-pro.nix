{
  autoPatchelfHook,
  cairo,
  copyDesktopItems,
  dbus,
  fontconfig,
  freetype,
  glib,
  gtk3,
  lib,
  libGL,
  libdrm,
  libice,
  libkrb5,
  libsecret,
  libsm,
  libunwind,
  libx11,
  libxau,
  libxcb,
  libxcb-cursor,
  libxext,
  libxi,
  libxkbcommon,
  libxrender,
  libxtst,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  makeDesktopItem,
  makeWrapper,
  openssl,
  patchelf,
  perl,
  python313,
  requireFile,
  stdenv,
  zlib,
  hexPatches ? [ ],
}:
let
  libida = requireFile {
    name = "libida.so";
    url = "https://my.hex-rays.com/";
    sha256 = "d16dffb4515157c7b2baef8c68d6df4055c1ddc4c6bc3f9da4cbadcb53aa3430";
  };

  libida32 = requireFile {
    name = "libida32.so";
    url = "https://my.hex-rays.com/";
    sha256 = "b9695790c93a3ceaa282f6e1cdcbe58471ec532e304118803e7510a1c7e9c364";
  };

  patchScript = lib.concatMapStringsSep "\n" (
    p:
    let
      forcecntDecl = lib.optionalString (p ? assertCount) "my $forcecnt = ${toString p.assertCount};";
    in
    ''
      perl -0777 -pi -e '${forcecntDecl} my $cnt = (s/\Q''${\pack("H*","${p.from}")}\E/''${\pack("H*","${p.to}")}/g) || 0; die "Expected $forcecnt substitutions, did $cnt\n" if defined $forcecnt && $cnt != $forcecnt' "$IDADIR/${p.filename}"
    ''
  ) hexPatches;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ida-pro";
  version = "9.4.260714";

  src = requireFile {
    name = "ida-pro_94_x64linux.run";
    url = "https://my.hex-rays.com/";
    sha256 = "eabb64c3c849d3858759558359e9cebcf17e2a91bcc60523533df8b84462aa54";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    patchelf
    perl
  ];

  dontUnpack = true;

  runtimeDependencies = [
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libsecret
    libunwind
    libxkbcommon
    openssl
    python313
    stdenv.cc.cc
    libice
    libsm
    libx11
    libxau
    libxcb
    libxcb-cursor
    libxext
    libxi
    libxrender
    libxtst
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    zlib
  ];

  buildInputs = finalAttrs.runtimeDependencies;

  autoPatchelfIgnoreMissingDeps = [
    "libQt6Network.so.6"
    "libQt6EglFSDeviceIntegration.so.6"
    "libQt6WaylandEglClientHwIntegration.so.6"
    "libQt6WaylandCompositor.so.6"
    "libQt6WlShellIntegration.so.6"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ida-pro";
      exec = "ida";
      icon = "ida-pro";
      desktopName = "IDA Pro";
      genericName = "Interactive Disassembler";
      categories = [ "Development" ];
      startupWMClass = "IDA";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib" "$out/opt" "$out/share/pixmaps"

    IDADIR="$out/opt"
    HOME="$out"

    $(cat "$NIX_CC/nix-support/dynamic-linker") "$src" \
      --mode unattended --prefix "$IDADIR"

    install -m 0644 "${libida}" "$IDADIR/libida.so"
    install -m 0644 "${libida32}" "$IDADIR/libida32.so"

    ${patchScript}

    for libFile in "$IDADIR"/*.so "$IDADIR"/*.so.6; do
      [ -f "$libFile" ] || continue
      ln -s "$libFile" "$out/lib/$(basename "$libFile")"
    done

    addAutoPatchelfSearchPath "$IDADIR"

    patchelf --add-needed libpython3.13.so "$IDADIR/libida.so"
    patchelf --add-needed libcrypto.so "$IDADIR/libida.so"
    patchelf --add-needed libsecret-1.so.0 "$IDADIR/libida.so"

    if [ -f "$IDADIR/appico.png" ]; then
      ln -s "$IDADIR/appico.png" "$out/share/pixmaps/ida-pro.png"
    fi

    wrapProgram "$IDADIR/ida" \
      --set IDADIR "$IDADIR" \
      --prefix QT_PLUGIN_PATH : "$IDADIR/plugins"

    ln -s "$IDADIR/ida" "$out/bin/ida"

    if [ -f "$IDADIR/tools/teams/git-ida" ]; then
      ln -s "$IDADIR/tools/teams/git-ida" "$out/bin/git-ida"
    fi

    runHook postInstall
  '';

  meta = {
    description = "IDA Pro";
    homepage = "https://hex-rays.com/ida-pro/";
    license = lib.licenses.unfree;
    mainProgram = "ida";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
