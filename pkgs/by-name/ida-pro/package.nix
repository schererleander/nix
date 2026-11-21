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
  python313,
  requireFile,
  stdenv,
  zlib,
}:
let
  # IDAPython in this release uses the Python 3.13 ABI.
  python = python313;

  libida = requireFile {
    name = "libida.so";
    url = "https://my.hex-rays.com/";
    hash = "sha256-0W3/tFFRV8eyuu+MaNbfQFXB3cTGvD+dpMuty1OqNDA=";
  };

  libida32 = requireFile {
    name = "libida32.so";
    url = "https://my.hex-rays.com/";
    hash = "sha256-uWlXkMk6POqigvbhzcvlhHHsUy4wQRiAPnUQocfpw2Q=";
  };
in
stdenv.mkDerivation {
  pname = "ida-pro";
  version = "9.4.260714";

  src = requireFile {
    name = "ida-pro_94_x64linux.run";
    url = "https://my.hex-rays.com/";
    hash = "sha256-6rtkw8hJ04WHWVWDWenOvPF+KpG8xgUjUz34uERiqlQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  dontUnpack = true;

  buildInputs = [
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
    python
    stdenv.cc.cc.lib
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

  # These are loaded dynamically; keep their paths without changing DT_NEEDED.
  runtimeDependencies = map lib.getLib [
    python
    openssl
    libsecret
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

    mkdir -p "$out/bin" "$out/opt" "$out/share/pixmaps"

    IDADIR="$out/opt"
    installerHome="$NIX_BUILD_TOP/installer-home"
    mkdir -p "$installerHome"

    HOME="$installerHome" $(cat "$NIX_CC/nix-support/dynamic-linker") "$src" \
      --mode unattended --prefix "$IDADIR"

    install -m 0644 "${libida}" "$IDADIR/libida.so"
    install -m 0644 "${libida32}" "$IDADIR/libida32.so"

    # These optional vendor backends lack their private Qt dependencies. Remove
    # them rather than mixing nixpkgs Qt with the bundled Qt ABI.
    rm "$IDADIR/libQt6WaylandEglCompositorHwIntegration.so.6" \
      "$IDADIR/plugins/platforms/libqeglfs.so" \
      "$IDADIR/plugins/wayland-shell-integration/libwl-shell-plugin.so"

    addAutoPatchelfSearchPath "$IDADIR"

    ln -s "$IDADIR/appico.png" "$out/share/pixmaps/ida-pro.png"

    wrapProgram "$IDADIR/ida" \
      --set IDADIR "$IDADIR" \
      --run '"$IDADIR/idapyswitch" --force-path "${lib.getLib python}/lib/libpython${python.pythonVersion}.so" >/dev/null' \
      --prefix QT_PLUGIN_PATH : "$IDADIR/plugins"

    ln -s "$IDADIR/ida" "$out/bin/ida"

    ln -s "$IDADIR/tools/teams/git-ida" "$out/bin/git-ida"

    runHook postInstall
  '';

  passthru.python = python;

  meta = {
    description = "Interactive disassembler and debugger";
    homepage = "https://hex-rays.com/ida-pro/";
    license = lib.licenses.unfree;
    mainProgram = "ida";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
