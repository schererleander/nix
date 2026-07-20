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
      packages.open-goal-launcher = pkgs.callPackage (
        {
          cairo,
          cmake,
          copyDesktopItems,
          fetchFromGitHub,
          fetchYarnDeps,
          glib,
          glib-networking,
          gtk3,
          lib,
          libayatana-appindicator,
          librsvg,
          libsoup_3,
          makeDesktopItem,
          nodejs,
          openssl,
          pango,
          pkg-config,
          rustPlatform,
          stdenv,
          webkitgtk_4_1,
          wrapGAppsHook3,
          yarn,
          yarnConfigHook,
        }:
        let
          version = "2.10.4";

          src = fetchFromGitHub {
            owner = "open-goal";
            repo = "launcher";
            rev = "v${version}";
            hash = "sha256-8ceTadkf1E4uTrxkLj131KoBf34GuIiku1CCqyLwbwU=";
          };

          desktopItem = makeDesktopItem {
            name = "open-goal-launcher";
            desktopName = "OpenGOAL Launcher";
            genericName = "OpenGOAL Launcher";
            comment = "Install and manage OpenGOAL game releases";
            exec = "open-goal-launcher";
            icon = "open-goal-launcher";
            terminal = false;
            categories = [
              "Game"
              "Utility"
            ];
          };
        in
        rustPlatform.buildRustPackage {
          pname = "open-goal-launcher";
          inherit version src;

          strictDeps = true;

          cargoRoot = "src-tauri";
          buildAndTestSubdir = "src-tauri";

          cargoLock = {
            lockFile = "${src}/src-tauri/Cargo.lock";
          };

          offlineCache = fetchYarnDeps {
            yarnLock = "${src}/yarn.lock";
            hash = "sha256-be8jhKeVkomrYFjYu/cM21mCDRRysjbtUUW9+MWB4Fo=";
          };

          desktopItems = [ desktopItem ];

          nativeBuildInputs = [
            cmake
            copyDesktopItems
            nodejs
            pkg-config
            wrapGAppsHook3
            yarn
            yarnConfigHook
          ];

          buildInputs = [
            cairo
            glib
            glib-networking
            gtk3
            libayatana-appindicator
            librsvg
            libsoup_3
            openssl
            pango
            webkitgtk_4_1
          ];

          env.OPENSSL_NO_VENDOR = "1";

          preBuild = ''
            pushd "$NIX_BUILD_TOP/$sourceRoot"
            yarn --offline build
            popd
          '';

          doCheck = false;

          installPhase = ''
            runHook preInstall

            root="$NIX_BUILD_TOP/$sourceRoot"

            launcher="$(
              find "$root/target" \
                -type f \
                -path "*/release/opengoal-launcher" \
                -perm -0100 \
                -print \
                -quit
            )"

            if [ -z "$launcher" ]; then
              echo "Could not find the compiled OpenGOAL Launcher executable"
              find "$root/target" -maxdepth 4 -type f -print
              exit 1
            fi

            install -Dm755 \
              "$launcher" \
              "$out/bin/open-goal-launcher"

            install -Dm644 \
              "$root/src-tauri/icons/32x32.png" \
              "$out/share/icons/hicolor/32x32/apps/open-goal-launcher.png"

            install -Dm644 \
              "$root/src-tauri/icons/128x128.png" \
              "$out/share/icons/hicolor/128x128/apps/open-goal-launcher.png"

            install -Dm644 \
              "$root/src-tauri/icons/128x128@2x.png" \
              "$out/share/icons/hicolor/256x256/apps/open-goal-launcher.png"

            runHook postInstall
          '';

          preFixup = ''
            gappsWrapperArgs+=(
              --set WEBKIT_DISABLE_DMABUF_RENDERER 1
            )
          '';

          meta = {
            description = "Launcher for installing and managing OpenGOAL releases";
            homepage = "https://github.com/open-goal/launcher";
            license = lib.licenses.isc;
            mainProgram = "open-goal-launcher";
            platforms = [ "x86_64-linux" ];
          };
        }
      ) { };
    };

  flake.modules.nixos.open-goal-launcher =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.open-goal-launcher
      ];
    };

  flake.modules.homeManager.open-goal-launcher =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.open-goal-launcher
      ];
    };
}
