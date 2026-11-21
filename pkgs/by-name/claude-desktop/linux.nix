{
  stdenvNoCC,
  buildFHSEnv,
  dpkg,
  fetchurl,
  OVMF,
  meta,
}:
let
  inherit (stdenvNoCC) hostPlatform;

  sources = {
    x86_64-linux = {
      arch = "amd64";
      hash = "sha256-uWIIsgfkULdA99vjBPYHf+2A5/PTfd1UWZHE6CAVZM8=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-/mzYpw+WuW605rZHMAz67mqv9M4TOg+74Rws23dfWmo=";
    };
  };

  unwrapped = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "claude-desktop-unwrapped";
    version = "5.11492.5";

    src =
      let
        source = sources.${hostPlatform.system};
      in
      fetchurl {
        url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_${source.arch}.deb";
        inherit (source) hash;
      };

    # dpkg's setup hook unpacks the .deb.
    strictDeps = true;
    nativeBuildInputs = [ dpkg ];

    # Preserve the bundled Electron runtime, native modules, and VM images.
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/lib" "$out/share"
      cp -a usr/lib/claude-desktop "$out/lib/"
      cp -a usr/share/applications usr/share/icons "$out/share/"
      runHook postInstall
    '';

    meta = meta // {
      platforms = builtins.attrNames sources;
    };
  });

  firmware = if hostPlatform.isAarch64 then "AAVMF" else "OVMF";
in
buildFHSEnv {
  pname = "claude-desktop";
  inherit (unwrapped) version meta;

  # Cowork uses absolute Debian paths for QEMU and firmware. The integrated
  # terminal and downloaded tools also require a standard Linux filesystem.
  multiArch = false;
  targetPkgs = p: [
    p.alsa-lib
    p.at-spi2-atk
    p.at-spi2-core
    p.atk
    p.bash
    p.bubblewrap
    p.cacert
    p.cairo
    p.coreutils
    p.cups
    p.curl
    p.dbus
    p.expat
    p.fontconfig
    p.freetype
    p.gdk-pixbuf
    p.git
    p.glib
    p.gsettings-desktop-schemas
    p.gtk3
    p.libayatana-appindicator
    p.libdrm
    p.libgbm
    p.libGL
    p.libnotify
    p.libsecret
    p.libuuid
    p.libx11
    p.libxcb
    p.libxcomposite
    p.libxdamage
    p.libxext
    p.libxfixes
    p.libxkbcommon
    p.libxrandr
    p.libxtst
    p.mesa
    p.nspr
    p.nss
    p.openssh
    p.pango
    p.pipewire
    p.qemu
    p.socat
    p.stdenv.cc.cc.lib
    p.systemd
    p.virtiofsd
    p.wayland
    p.xdg-utils
    p.zlib
  ];

  extraBuildCommands = ''
    mkdir -p "$out/usr/share/${firmware}"
    ln -s ${OVMF.fd}/FV/${firmware}_CODE.fd "$out/usr/share/${firmware}/${firmware}_CODE.fd"
    ln -s ${OVMF.fd}/FV/${firmware}_VARS.fd "$out/usr/share/${firmware}/${firmware}_VARS.fd"
  '';

  runScript = "${unwrapped}/lib/claude-desktop/claude-desktop";

  extraInstallCommands = ''
    ln -s ${unwrapped}/share "$out/share"
  '';

  passthru = { inherit unwrapped; };
}
