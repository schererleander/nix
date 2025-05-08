{
  lib,
  stdenv,
  fetchurl,

  dpkg,
  autoPatchelfHook,

  libxkbcommon,
  libxcb,
  xorg,
  alsa-lib,
  nss,
  at-spi2-core,
  mesa,
  cairo,
  pango,
  cups,
  gtk3,
  glib,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: let
  system = stdenv.hostPlatform.system;

  asset = if lib.strings.hasPrefix "x86_64-linux" system then {
     url = "https://github.com/minbrowser/min/releases/download/v${finalAttrs.version}/min-${finalAttrs.version}-amd64.deb";
    sha256 = "sha256-gpkjGYuHwBY3IwK5bXhzIPPosSTZ67hclmGLT4PTsG4=";
  } else if system == "x86_64-darwin" then {
    url = "https://github.com/minbrowser/min/releases/download/v${finalAttrs.version}/min-v${finalAttrs.version}-mac-x86_64.zip";
    sha256 = "";
  } else if system == "aarch64-darwin" then {
    url = "https://github.com/minbrowser/min/releases/download/v${finalAttrs.version}/min-v${finalAttrs.version}-mac-arm64.zip";
    sha256 = "";
  } else throw "Unsupported plattform: ${system}";
  in {
  pname = "min";
  version = "1.34.1";

  src = fetchurl {
    url = asset.url;
    hash = asset.sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  nativeBuildInputs = lib.optional (lib.strings.hasPrefix "x86_64-linux" system) dpkg ++ [ autoPatchelHook ];

  buildInputs = [
    libxkbcommon libxcb at-spi2-core mesa cairo cups gtk3 pango
    alsa-lib nss glib stdenv.cc.cc.lib
  ] ++ (with xorg; [ libX11 libXcomposite libXdamage libXext libXfixes libXrandr ]);

  unpackPhase = ''
    ${lib.optionalString (lib.strings.hasPrefix "x86_64-linux" system) ''
      dpkg-deb -x $src $out
      mv $out/usr/share $out
    ''}
    ${lib.optionalString (system == "x86_64-darwin" || system == "aarch64-darwin") ''
      unzip $src -d $out
      # the zip contains e.g. Min.app; flatten:
      mv $out/Min.app/Contents/* $out/
    ''}
    mkdir -p $out/bin
    ln -s $out/opt/Min/min $out/bin/min
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, minimal browser that protects your privacy";
    homepage = "https://github.com/minbrowser/min";
    changelog = "https://github.com/minbrowser/min/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
  };
})
