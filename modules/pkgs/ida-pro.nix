{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.ida-pro = pkgs.callPackage (
        {
          autoPatchelfHook,
          cairo,
          copyDesktopItems,
          curl,
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
          libxcrypt-legacy,
          libxext,
          libxi,
          libxkbcommon,
          libxrender,
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
          qt6,
          requireFile,
          stdenv,
          zlib,
        }:
        let
          pythonForIDA = python313.withPackages (ps: with ps; [ rpyc ]);

          src = requireFile {
            name = "ida-pro_93_x64linux.run";
            url = "https://my.hex-rays.com/";
            sha256 = "a64e6589feeca0f4e1bfb962d1a283761fb38c5158f5f82c8f1e7ddf32f69850";
          };

          libida = requireFile {
            name = "libida.so";
            url = "https://my.hex-rays.com/";
            sha256 = "86cff5a0dbf26eb56076313181e9ca8e7db48212d60d00588217cfac36060531";
          };

          libida32 = requireFile {
            name = "libida32.so";
            url = "https://my.hex-rays.com/";
            sha256 = "55afb0edcec85139b99cb36c80d460ab7679c87e50bf4d5b111f7910935e69c2";
          };

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
            qt6.qtbase
            qt6.qtwayland
            libunwind
            libxkbcommon
            openssl.out
            stdenv.cc.cc
            libice
            libsm
            libx11
            libxau
            libxcb
            libxcrypt-legacy
            libxext
            libxi
            libxrender
            libxcb-image
            libxcb-keysyms
            libxcb-render-util
            libxcb-wm
            zlib
            curl.out
            pythonForIDA
          ];
        in
        stdenv.mkDerivation rec {
          pname = "ida-pro";
          version = "9.3";

          inherit src;

          desktopItem = makeDesktopItem {
            name = "ida-pro";
            exec = "ida";
            icon = "ida-pro";
            comment = meta.description;
            desktopName = "IDA Pro";
            genericName = "Interactive Disassembler";
            categories = [ "Development" ];
            startupWMClass = "IDA";
          };

          desktopItems = [ desktopItem ];

          nativeBuildInputs = [
            makeWrapper
            copyDesktopItems
            autoPatchelfHook
            qt6.wrapQtAppsHook
            perl
            patchelf
          ];

          buildInputs = runtimeDependencies;

          dontUnpack = true;
          dontWrapQtApps = true;

          installPhase = ''
            runHook preInstall

            mkdir -p "$out/bin" "$out/lib" "$out/opt" "$out/share/pixmaps"

            IDADIR="$out/opt"
            HOME="$out/opt"

            $(cat "$NIX_CC/nix-support/dynamic-linker") "$src" \
              --mode unattended --debuglevel 4 --prefix "$IDADIR" || true

            install -m 0644 "${libida}" "$IDADIR/libida.so"
            install -m 0644 "${libida32}" "$IDADIR/libida32.so"

            for libFile in "$IDADIR"/*.so "$IDADIR"/*.so.6; do
              ln -s "$libFile" "$out/lib/$(basename "$libFile")"
            done

            patchelf --add-needed libpython3.13.so "$out/lib/libida.so"
            patchelf --add-needed libcrypto.so "$out/lib/libida.so"
            patchelf --add-needed libsecret-1.so.0 "$out/lib/libida.so"

            addAutoPatchelfSearchPath "$IDADIR"

            if [ -f "$IDADIR/appico.png" ]; then
              ln -s "$IDADIR/appico.png" "$out/share/pixmaps/ida-pro.png"
            fi

            wrapProgram "$IDADIR/ida" \
              --prefix IDADIR : "$IDADIR" \
              --prefix QT_PLUGIN_PATH : "$IDADIR/plugins/platforms" \
              --prefix PYTHONPATH : "$out/bin/idalib/python" \
              --prefix PATH : "${pythonForIDA}/bin:$IDADIR" \
              --prefix LD_LIBRARY_PATH : "$out/lib" \
              --set QT_QPA_PLATFORM xcb

            ln -s "$IDADIR/ida" "$out/bin/ida"

            runHook postInstall
          '';

          meta = with lib; {
            description = "IDA Pro";
            homepage = "https://hex-rays.com/ida-pro/";
            license = licenses.unfree;
            mainProgram = "ida";
            platforms = [ "x86_64-linux" ];
            sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          };
        }
      ) { };
    };

  flake.modules.nixos.ida-pro =
    { pkgs, ... }:
    {
      environment.systemPackages = [ inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.ida-pro ];
    };

  flake.modules.homeManager.ida-pro =
    { pkgs, ... }:
    {
      home.packages = [ inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.ida-pro ];
    };
}
