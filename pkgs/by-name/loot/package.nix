{
  stdenv,
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
  cmake,
  ninja,
  pkg-config,
  qt6,
  boost,
  icu,
  tbb,
  libloot,
  zlib,
  libx11,
  openssl,
  fmt,
  spdlog,
  minizip-ng,
  tomlplusplus,
  gettext,
  bzip2,
  xz,
  zstd,
  ogdf,
}:
let
  valveFileVdf = fetchFromGitHub {
    owner = "TinyTinni";
    repo = "ValveFileVDF";
    tag = "v1.1.1";
    hash = "sha256-s7wyHIcqMDHTSudIgy/bzZixQCL/T+ziFQxZh8w15uE=";
  };

  # Match the icon generator in LOOT's Linux release manifest.
  svgToIco = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "svg-to-ico";
    version = "1.3.1";
    src = fetchurl {
      url = "https://github.com/Ortham/svg_to_ico/releases/download/${finalAttrs.version}/svg_to_ico.tar.xz";
      hash = "sha256-BIl7Y4TnwxQcg0MzW2a947GE19ZZQJgMOGibPvRFPy8=";
    };

    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];

    installPhase = ''
      runHook preInstall
      install -Dm755 svg_to_ico "$out/bin/svg_to_ico"
      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "loot";
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "loot";
    repo = "loot";
    tag = finalAttrs.version;
    hash = "sha256-lZWGNj8Wsi/l4GnJsggl/trovQZf4XJUfVJrT3PYsvY=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    gettext
    svgToIco
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    qt6.qtsvg
    boost
    icu
    tbb
    libloot
    zlib
    libx11
    fmt
    spdlog
    minizip-ng
    tomlplusplus
    bzip2
    xz
    zstd
    openssl
    ogdf
  ];

  cmakeFlags = [
    (lib.cmakeBool "LOOT_BUILD_TESTS" false)
    (lib.cmakeBool "LOOT_RUN_CLANG_TIDY" false)
    (lib.cmakeBool "Boost_USE_STATIC_LIBS" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_VALVEFILEVDF" "${valveFileVdf}")
    (lib.cmakeFeature "libloot_DIR" "${lib.getDev libloot}/lib/cmake/libloot")
  ];

  ninjaFlags = [ "LOOT" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 LOOT "$out/bin/loot"
    ln -s loot "$out/bin/LOOT"
    install -Dm644 ../resources/icons/loot.svg \
      "$out/share/icons/hicolor/scalable/apps/io.github.loot.loot.svg"
    install -Dm644 ../resources/linux/io.github.loot.loot.desktop \
      "$out/share/applications/io.github.loot.loot.desktop"

    for translation in ../resources/l10n/*/LC_MESSAGES/loot.po; do
      locale="''${translation#../resources/l10n/}"
      locale="''${locale%%/*}"
      mkdir -p "$out/share/locale/$locale/LC_MESSAGES"
      msgfmt "$translation" -o "$out/share/locale/$locale/LC_MESSAGES/loot.mo"
    done

    runHook postInstall
  '';

  meta = {
    description = "Load Order Optimisation Tool for Bethesda games";
    homepage = "https://github.com/loot/loot";
    changelog = "https://github.com/loot/loot/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "loot";
  };
})
