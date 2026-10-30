{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    lib.optionalAttrs (system == "x86_64-linux") {
      packages.loot = pkgs.callPackage (
        {
          stdenv,
          lib,
          fetchFromGitHub,
          fetchzip,
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
          valveFileVdf = fetchzip {
            url = "https://github.com/TinyTinni/ValveFileVDF/archive/refs/tags/v1.1.1.tar.gz";
            hash = "sha256-s7wyHIcqMDHTSudIgy/bzZixQCL/T+ziFQxZh8w15uE=";
          };
        in
        stdenv.mkDerivation (finalAttrs: {
          pname = "loot";
          # Matches stable nixpkgs' libloot 0.25.5 and OGDF 2023.09.
          version = "0.25.2";

          src = fetchFromGitHub {
            owner = "loot";
            repo = "loot";
            tag = finalAttrs.version;
            hash = "sha256-vlae4WltXPvA8T6hrD9/GeEAb1SZPu9zZpMbnj+xU3U=";
          };

          strictDeps = true;
          nativeBuildInputs = [
            cmake
            ninja
            pkg-config
            qt6.wrapQtAppsHook
            gettext
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
            # minizip-ng's CMake configuration looks up its dependencies.
            bzip2
            xz
            zstd
            openssl
            # Automatic layout of the group load-order graph in the groups editor.
            ogdf
          ];

          postPatch = ''
            # nixpkgs' minizip-ng exports a suffixed CMake package and target.
            substituteInPlace CMakeLists.txt \
              --replace-fail 'URL_HASH ''${MINIZIP_NG_HASH}
                    FIND_PACKAGE_ARGS)' 'URL_HASH ''${MINIZIP_NG_HASH}
                    FIND_PACKAGE_ARGS NAMES minizip-ng)' \
              --replace-fail 'MINIZIP::minizip)' 'MINIZIP::minizip-ng)'

            # Newer Qt no longer includes QJsonObject and QJsonValue transitively.
            substituteInPlace src/gui/qt/tasks/check_for_update_task.cpp \
              --replace-fail '#include <QtCore/QJsonDocument>' \
                '#include <QtCore/QJsonDocument>
            #include <QtCore/QJsonObject>
            #include <QtCore/QJsonValue>'
          '';

          cmakeFlags = [
            (lib.cmakeBool "LOOT_BUILD_TESTS" false)
            (lib.cmakeBool "LOOT_RUN_CLANG_TIDY" false)
            (lib.cmakeBool "Boost_USE_STATIC_LIBS" false)
            (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
            (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_VALVEFILEVDF" "${valveFileVdf}")
            (lib.cmakeFeature "libloot_DIR" "${lib.getDev libloot}/lib/cmake/libloot")
          ];

          ninjaFlags = [ "LOOT" ];

          # Upstream has no install target.
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
      ) { };
    };

  flake.modules.nixos.loot =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.loot
      ];
    };

  flake.modules.homeManager.loot =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.loot
      ];
    };
}
