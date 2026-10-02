{
  alsa-lib,
  copyDesktopItems,
  fetchFromGitHub,
  gtk3,
  lib,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  llvmPackages_19,
  makeDesktopItem,
  openssl,
  patchelf,
  pkg-config,
  vulkan-headers,
  vulkan-loader,
  wrapGAppsHook3,
}:
let
  stdenv = llvmPackages_19.stdenv;
  amakePlatform =
    {
      "x86_64-linux" = "linux_x64";
      "aarch64-linux" = "linux_arm64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "ArmorPaint does not provide amake for ${stdenv.hostPlatform.system}");
  rev = "d8803e6e30e77a7a90abc691ceb9adab8714fd93";
in
stdenv.mkDerivation {
  pname = "armorpaint";
  version = "1.1alpha-unstable-2026-09-28";

  src = fetchFromGitHub {
    owner = "armory3d";
    repo = "armorpaint";
    inherit rev;
    hash = "sha256-O7/V9DoYzfBHUaFMqGm0Hiwcoqdp9kwnz0gr1XFyBXo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    patchelf
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libx11
    libxcursor
    libxi
    libxrandr
    openssl
    vulkan-headers
    vulkan-loader
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "armorpaint";
      desktopName = "ArmorPaint";
      exec = "ArmorPaint";
      icon = "armorpaint";
      categories = [ "Graphics" ];
    })
  ];

  postPatch = ''
    patchShebangs base/make

    if patchelf --print-interpreter \
      base/tools/bin/${amakePlatform}/amake >/dev/null 2>&1; then
      patchelf \
        --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" \
        base/tools/bin/${amakePlatform}/amake
    fi

    # fetchFromGitHub does not include .git. Keep the version shown by
    # ArmorPaint tied to the exact source revision used by this package.
    if [[ -f base/project.c ]]; then
      substituteInPlace base/project.c \
        --replace-fail \
          'char *sha  = os_popen("git log --pretty=format:\"%h\" -n 1");' \
          'char *sha  = "${builtins.substring 0 7 rev}";'
    fi
  '';

  buildPhase = ''
    runHook preBuild

    appDir=paint
    if [[ ! -d "$appDir" && -d armorpaint ]]; then
      appDir=armorpaint
    fi

    export NIX_CFLAGS_COMPILE="$(pkg-config --cflags gtk+-3.0)''${NIX_CFLAGS_COMPILE:+ $NIX_CFLAGS_COMPILE}"

    pushd "$appDir"
    ../base/make --graphics vulkan --compile --embed
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appDir=paint
    if [[ ! -d "$appDir" && -d armorpaint ]]; then
      appDir=armorpaint
    fi

    # JSON, scripts and several other text assets are intentionally not
    # embedded. ArmorPaint resolves them relative to argv[0], so retain
    # upstream's complete build/out layout in $out/bin.
    mkdir -p "$out/bin"
    cp -R "$appDir/build/out/." "$out/bin/"

    install -Dm644 "$appDir/icon.png" \
      "$out/share/icons/hicolor/256x256/apps/armorpaint.png"

    runHook postInstall
  '';

  # The executable must remain beside its data directory, so wrap it in place.
  dontWrapGApps = true;
  postFixup = ''
    appDir=paint
    if [[ ! -d "$appDir" && -d armorpaint ]]; then
      appDir=armorpaint
    fi

    wrapperArgs=()
    if [[ -f "$appDir/project.js" ]]; then
      # Legacy builds reserve argv[1] for their assets directory. Current
      # builds locate assets relative to the executable instead.
      wrapperArgs+=(--add-flag "$out/bin")
    fi

    wrapGApp "$out/bin/ArmorPaint" "''${wrapperArgs[@]}"
  '';

  meta = {
    description = "3D PBR based texturing software";
    homepage = "https://armorpaint.org";
    changelog = "https://armorpaint.org/notes";
    license = lib.licenses.zlib;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "ArmorPaint";
    maintainers = with lib.maintainers; [ miampf ];
  };
}
