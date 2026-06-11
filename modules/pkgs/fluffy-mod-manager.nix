{ ... }:
{
  flake.overlays.fluffy-mod-manager = final: prev: {
    fluffy-mod-manager = final.callPackage (
      {
        lib,
        stdenv,
        makeWrapper,
        wine,
        requireFile,
        copyDesktopItems,
        makeDesktopItem,
        icoutils,
        imagemagick,
        unzip,
      }:
      stdenv.mkDerivation rec {
        pname = "fluffy-mod-manager";
        version = "3.016";

        src = requireFile {
          name = "fluffy-mod-manager.zip";
          url = "https://www.nexusmods.com/residentevil32020/mods/8";
          sha256 = "071sa9a8dw2zzk3pamhalfn8whzjp8ch3a6wjx6jqgp1g60k6ai6";
        };

        nativeBuildInputs = [ makeWrapper copyDesktopItems icoutils imagemagick unzip ];

        sourceRoot = ".";

        desktopItems = [
          (makeDesktopItem {
            name = "fluffy-mod-manager";
            exec = "fluffy-mod-manager";
            icon = "fluffy-mod-manager";
            desktopName = "Fluffy Mod Manager";
            categories = [ "Game" ];
            startupWMClass = "modmanager.exe";
          })
        ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/fluffy-mod-manager
          cp -r * $out/share/fluffy-mod-manager/

          mkdir -p $out/share/pixmaps
          EXE_NAME=$(find . -maxdepth 1 -iname "modmanager.exe" -print -quit)
          if [ -n "$EXE_NAME" ]; then
            wrestool -x -t 14 -n 105 "$EXE_NAME" -o fluffy.ico || true
            if [ -f fluffy.ico ]; then
              magick "fluffy.ico[0]" $out/share/pixmaps/fluffy-mod-manager.png || convert "fluffy.ico[0]" $out/share/pixmaps/fluffy-mod-manager.png || true
            fi
          fi

          mkdir -p $out/bin
          
          makeWrapper ${wine}/bin/wine $out/bin/fluffy-mod-manager \
            --run "export WINEPREFIX=\"''${WINEPREFIX:-\$HOME/.wine}\"" \
            --run "mkdir -p \"\$WINEPREFIX/drive_c/FluffyModManager\"" \
            --run "cp -rn $out/share/fluffy-mod-manager/* \"\$WINEPREFIX/drive_c/FluffyModManager/\"" \
            --run "chmod -R +w \"\$WINEPREFIX/drive_c/FluffyModManager\"" \
            --run "cd \"\$WINEPREFIX/drive_c/FluffyModManager\"" \
            --add-flags "Modmanager.exe"

          runHook postInstall
        '';

        meta = with lib; {
          description = "Mod manager for many Capcom games and others";
          homepage = "https://www.fluffymanager.com/";
          license = licenses.unfree;
          platforms = platforms.linux;
        };
      }
    ) {
      # Use Wow64 package to ensure 64-bit prefix compatibility
      wine = final.wineWow64Packages.waylandFull;
    };
  };

  flake.modules.homeManager.fluffy-mod-manager = { pkgs, ... }: {
    home.packages = [ pkgs.fluffy-mod-manager ];
  };
}
