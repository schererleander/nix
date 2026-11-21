{
  lib,
  stdenv,
  llvmPackages_23,
  python3,
  tk-wayland,
  runtimeShell,
  nix,
  runCommand,
  fetchFromGitea,
  fetchurl,
  makeWrapper,
  copyDesktopItems,
  unzip,
  makeDesktopItem,
  pkg-config,
  coreutils,
  gawk,
  procps,
  xdg-utils,
  xrdb,
  SDL2,
  ffmpeg,
  fsr4-vk,
  vulkan-loader,
  vulkan-headers,
  spirv-headers,
  vulkan-memory-allocator,
  withFsr4 ? true,
  withWayland ? true,
}:
let
  tkinter =
    if !withWayland then
      python3.pkgs.tkinter
    else
      (python3.pkgs.tkinter.override {
        inherit (tk-wayland) tcl;
        tk = tk-wayland;
      }).overrideAttrs
        {
          # Run the Tcl-only checks; Xvfb cannot exercise this Wayland backend.
          nativeInstallCheckInputs = [ ];
          installCheckPhase = ''
            runHook preCheck
            ${python3.interpreter} -m unittest test.test_tcl test.test_ttk_textonly
            runHook postCheck
          '';
        };
  python = python3.withPackages (
    p: with p; [
      lz4
      numpy
      capstone
      unicorn
      zstandard
      tkinter
      fonttools
      pillow
      astc-encoder-py
      texture2ddecoder
    ]
  );
  # LLVM 23 reads the shipped play profiles; use its wrapped compiler throughout.
  compiler = llvmPackages_23.stdenv.cc;
  # SDL carries its own audio, window-system and controller dependencies.
  libraries = [
    stdenv.cc.cc.lib
    SDL2
    ffmpeg
    vulkan-loader
  ];
  toolchain = [
    compiler
    llvmPackages_23.lld
    llvmPackages_23.llvm
    python
    pkg-config
  ];
  runtimeRpath = "$ORIGIN:${lib.makeLibraryPath libraries}:/run/opengl-driver/lib";
  nativeEnvironment = {
    HOOKSHOT_VULKAN_HEADERS = "${vulkan-headers}";
    HOOKSHOT_SPIRV_HEADERS = "${spirv-headers}";
    HOOKSHOT_VMA_HEADERS = "${vulkan-memory-allocator}";
    PKG_CONFIG_PATH = "${lib.getDev ffmpeg}/lib/pkgconfig";
  };
  buildEnvironment = nativeEnvironment // {
    RX_RELEASE = "1";
    # Match the declared host platform instead of probing the build machine or
    # requiring AVX2 on every x86_64 system.
    RX_MARCH = stdenv.hostPlatform.gcc.arch or "x86-64";
    HOOKSHOT_MEM_GATE = "0";
  };
  fsr4Flag = lib.optionalString withFsr4 "--set-default RX_VK_FSR_DIR '${fsr4-vk}/lib'";
  playPath = lib.makeBinPath [
    coreutils
    gawk
  ];
  builderPath =
    lib.makeBinPath (
      toolchain
      ++ [
        coreutils
        gawk
        procps
        xdg-utils
      ]
    )
    + lib.optionalString (!withWayland) ":${lib.makeBinPath [ xrdb ]}";
  # Use only the four game-free profiling-data files in this release part.
  # Matches v2.3.2: update together with src. Its SHA-256 is recorded in that
  # release's hookshot-linux.txt manifest (see README.md).
  profileData = fetchurl {
    url = "https://git.notrexed.dev/Hookshot/Hookshot/releases/download/linux-parts/HookshotLinux-usr-share-hookshot-d63aa364b31f.zip";
    hash = "sha256-1jqjZLMfeBi1iRT1SpbyPRvFwb6mTo3et42CGwiWqWA=";
  };
in
llvmPackages_23.stdenv.mkDerivation (finalAttrs: {
  pname = "hookshot";
  version = "2.3.2";
  src = fetchFromGitea {
    domain = "git.notrexed.dev";
    owner = "Hookshot";
    repo = "Hookshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MOIOcnhVQDbyJ2dT/yelWRWmGp0TwzVUe16/dhOfKB4=";
  };
  strictDeps = true;
  nativeBuildInputs = toolchain ++ [
    makeWrapper
    copyDesktopItems
    unzip
  ];
  buildInputs = libraries ++ [
    vulkan-headers
    spirv-headers
    vulkan-memory-allocator
  ];
  env = buildEnvironment;
  dontConfigure = true;
  patches = [
    ./nix-integration.patch
    ./retain-runtime.patch
    ./desktop-integration.patch
  ];

  postPatch = ''
    substituteInPlace third_party/a64-kit/tools/toolchain.py \
      --replace-fail '@nixClang@' '${compiler}/bin/clang' \
      --replace-fail '@nixClangxx@' '${compiler}/bin/clang++' \
      --replace-fail '@nixLld@' '${llvmPackages_23.lld}/bin/ld.lld' \
      --replace-fail '@nixLlvmBin@' '${llvmPackages_23.llvm}/bin'
    substituteInPlace nx2/build.py \
      --replace-fail '@nixInterpreter@' '${compiler.bintools.dynamicLinker}' \
      --replace-fail '@nixRpath@' ${lib.escapeShellArg runtimeRpath}
    substituteInPlace builder/linux/hookshot-folder \
      --replace-fail '@hookshotOut@' "$out" \
      --replace-fail '@nixPython@' '${python.interpreter}'
    # These scripts are read as data too, so shebang rewriting alone is not enough.
    substituteInPlace builder/linux/hookshot_builder.py \
      --replace-fail '"/bin/sh"' '"${runtimeShell}"'
    substituteInPlace builder/linux/hookshot-folder builder/linux/hookshot-launch \
      --replace-fail '#!/bin/sh' '#!${runtimeShell}'
    substituteInPlace builder/linux/hookshot-folder \
      --replace-fail '$(dirname ' '$(${coreutils}/bin/dirname ' \
      --replace-fail '$(tr ' '$(${coreutils}/bin/tr '
    substituteInPlace tests/test_linux_play_scope.py tests/test_linux_play_diagnostics.py \
      --replace-fail '/bin/sh' '${runtimeShell}'
    # The diagnostics fixture uses -Werror; Nix's fortify flags need optimization.
    substituteInPlace tests/test_linux_play_diagnostics.py \
      --replace-fail '"-O0"' '"-O2"'
    install -m644 ${./nix-runtime.py} nx2/nix_runtime.py
    substituteInPlace nx2/nix_runtime.py \
      --replace-fail '@hookshotOut@' "$out" \
      --replace-fail '@nixStore@' '${nix}/bin/nix-store'
    ${lib.optionalString withFsr4 ''
      substituteInPlace builder/linux/hookshot_builder.py \
        --replace-fail 'self.cfg.get("fsr", "0")' 'self.cfg.get("fsr", "1")'
    ''}
    printf 'v%s\n' '${finalAttrs.version}' > VERSION
    unzip -oq ${profileData} -d . \
      work/hot_funcs.txt work/hot_order.txt work/hookshot_pieces.prof work/image/chunks.txt
  '';

  buildPhase = ''
    runHook preBuild
    # Compile helpers from source; never use native binaries shipped in a tree.
    find third_party/a64-kit/lift -maxdepth 1 \
      \( -name 'liba64emit.so*' -o -name 'a64emit.dll*' \) -delete
    find third_party/zbic -maxdepth 1 \
      \( -name 'zbic.so' -o -name 'zbic.dll' \) -delete
    ${python.interpreter} -I third_party/a64-kit/lift/build_emit.py
    ${python.interpreter} -I -c 'import sys; sys.path.insert(0, "nx2"); import zbic; zbic.lib()'
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -I -c 'import lz4.block, numpy, capstone, unicorn, zstandard, tkinter, fontTools, PIL, astc_encoder, texture2ddecoder'
    ${python.interpreter} -I nx2/make_game.py --help >/dev/null
    ${python.interpreter} -I -c 'import sys; sys.path.insert(0, "third_party/a64-kit/lift"); import a64emit'
    ${python.interpreter} -I -B tests/test_linux_play_scope.py
    ${python.interpreter} -I -B tests/test_linux_play_diagnostics.py --cxx '${compiler}/bin/clang++'
    runHook postCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "hookshot-builder";
      desktopName = "Hookshot Builder";
      comment = "Build and manage Hookshot";
      exec = "hookshot";
      icon = "hookshot";
      categories = [ "Game" ];
      actions.Play = {
        name = "Play";
        exec = "hookshot --play";
        icon = "hookshot";
      };
    })
    (makeDesktopItem {
      name = "hookshot";
      desktopName = "Hookshot";
      comment = "Play Hookshot";
      exec = "hookshot-play";
      icon = "hookshot";
      startupWMClass = "io.github.pixl27.ProjectHookshot";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    tools="$out/share/hookshot"
    mkdir -p "$tools" "$out/bin"
    cp -r nx2 host gpu third_party builder scripts assets work LICENSE VERSION "$tools/"
    rm "$tools/builder/linux/AppRun"
    find "$tools" -name __pycache__ -type d -prune -exec rm -r -- {} +
    install -Dm644 assets/hookshot.png "$out/share/pixmaps/hookshot.png"
    makeWrapper "$tools/builder/linux/hookshot-launch" "$out/bin/hookshot-play" \
      --prefix PATH : '${playPath}' \
      ${fsr4Flag}
    # Wrap the upstream Python entry points directly, without an AppImage dispatcher.
    for entry in hookshot:builder/linux/hookshot_builder.py hookshot-cli:nx2/make_game.py; do
      makeWrapper ${python.interpreter} "$out/bin/''${entry%%:*}" \
        --add-flags "-I $tools/''${entry#*:}" \
        --prefix PATH : '${builderPath}' \
        --unset EMSDK --unset HOOKSHOT_SYSROOT --unset HOOKSHOT_FFMPEG --unset RX_CPM \
        --set HOOKSHOT_TOOLS "$tools" \
        --set HOOKSHOT_BUILDER_EXE "$out/bin/hookshot" \
        --set HOOKSHOT_SDL2 '${lib.getLib SDL2}/lib/libSDL2-2.0.so.0' \
        --set HOOKSHOT_LATEST_TAG none \
        ${fsr4Flag} \
        ${lib.concatStringsSep " " (
          lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") nativeEnvironment
        )}
    done
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    ${python.interpreter} -B ${./test-package.py} "$out" '${runtimeShell}'
    runHook postInstallCheck
  '';

  passthru.tests.renderer =
    runCommand "hookshot-renderer-check"
      {
        nativeBuildInputs = toolchain;
        env = buildEnvironment // {
          RX_VK_ONLY = "1";
          HOOKSHOT_FSR = if withFsr4 then "1" else "0";
        };
      }
      ''
        # Use the installed toolchain paths without buildInputs injecting headers
        # or libraries that would be missing from a player's environment.
        export OOT_WORK="$TMPDIR/renderer-work"
        ${python.interpreter} -I ${finalAttrs.finalPackage}/share/hookshot/nx2/build.py \
          --standalone --jobs "$NIX_BUILD_CORES"
        test -s "$OOT_WORK/sa/build/hookshot_vk.so"
        mkdir -p "$out"
      '';
  meta = {
    description = "Builder and launcher for native Linux game recompilations";
    homepage = "https://git.notrexed.dev/Hookshot/Hookshot";
    license = lib.licenses.gpl3Plus;
    mainProgram = "hookshot";
    platforms = [ "x86_64-linux" ];
  };
})
