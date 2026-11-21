{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  fetchurl,
  python3,
  copyDesktopItems,
  makeDesktopItem,
}:
let
  # Version and checksum: https://launcher.hytale.com/version/release/launcher.json
  version = "2026.11.16-1726018";

  icon = fetchurl {
    url = "https://hytale.com/images/favicon.png";
    hash = "sha256-eniMb/wct+vjtzXF2z8Z1XPBmwabjV8RCDyd8J1QLT0=";
  };

  launcher = stdenvNoCC.mkDerivation {
    pname = "hytale-launcher-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${version}.zip";
      hash = "sha256-JDQeUKnj7jf/z2iUO7kk3I0K8YBx+j/eVdJ1WprdVP4=";
    };

    strictDeps = true;
    nativeBuildInputs = [
      python3
      copyDesktopItems
    ];

    # Upstream prepends signed update metadata to the ZIP. Python's ZIP
    # reader handles this without unzip's nonzero warning status.
    unpackPhase = ''
      runHook preUnpack
      python -m zipfile -e "$src" .
      runHook postUnpack
    '';

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    desktopItems = [
      (makeDesktopItem {
        name = "hytale-launcher";
        desktopName = "Hytale Launcher";
        genericName = "Game Launcher";
        exec = "hytale-launcher";
        icon = "hytale-launcher";
        categories = [ "Game" ];
      })
    ];

    installPhase = ''
      runHook preInstall
      install -Dm755 hytale-launcher "$out/libexec/hytale-launcher"
      install -Dm644 ${icon} \
        "$out/share/icons/hicolor/16x16/apps/hytale-launcher.png"
      mkdir -p "$out/share/hytale-launcher"
      sha256sum hytale-launcher | cut -d ' ' -f1 \
        > "$out/share/hytale-launcher/bundled-hash"
      runHook postInstall
    '';
  };
in
buildFHSEnv {
  pname = "hytale-launcher";
  inherit version;

  # The native launcher downloads the game and a JRE. They need the
  # standard Linux dynamic linker and libraries as well as the launcher.
  multiArch = false;
  targetPkgs = p: [
    p.alsa-lib
    p.dbus
    p.gdk-pixbuf
    p.glib
    p.glib-networking
    p.gsettings-desktop-schemas
    p.gtk3
    p.icu
    p.libGL
    p.libsoup_3
    p.libx11
    p.libxcursor
    p.libxi
    p.libxrandr
    p.libxkbcommon
    p.mesa
    p.openal
    p.openssl
    p.libpulseaudio
    p.stdenv.cc.cc.lib
    p.vulkan-loader
    p.wayland
    p.webkitgtk_4_1
    p.zlib
  ];

  runScript = "${launcher}/libexec/hytale-launcher";
  profile = lib.replaceStrings [ "@launcher@" ] [ "${launcher}" ] (builtins.readFile ./profile.sh);

  extraInstallCommands = ''
    ln -s ${launcher}/share "$out/share"
  '';

  passthru.unwrapped = launcher;

  meta = {
    description = "Official Hytale game launcher";
    homepage = "https://hytale.com";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "hytale-launcher";
  };
}
