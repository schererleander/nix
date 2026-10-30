{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    # Upstream's physics preview requires x86 SSE intrinsics.
    lib.optionalAttrs (system == "x86_64-linux") {
      packages.bodyslide = pkgs.callPackage (
        {
          stdenv,
          lib,
          fetchFromGitHub,
          cmake,
          ninja,
          pkg-config,
          copyDesktopItems,
          makeDesktopItem,
          wrapGAppsHook3,
          makeWrapper,
          writeShellApplication,
          coreutils,
          gtk3,
          wxwidgets_3_2,
          libGL,
          libGLU,
          glew,
          directx-headers,
          bullet,
          openexr,
          imath,
        }:
        let
          launcher = writeShellApplication {
            name = "bodyslide-start";
            runtimeInputs = [ coreutils ];
            text = ''
              export BODYSLIDE_DATA_DIR="''${BODYSLIDE_DATA_DIR:-''${XDG_DATA_HOME:-$HOME/.local/share}/bodyslide}"
              mkdir -p "$BODYSLIDE_DATA_DIR"

              # Keep user settings and projects writable while sharing the
              # immutable resources between both applications.
              cp --update=none --no-preserve=mode "$1"/share/bodyslide/*.xml "$BODYSLIDE_DATA_DIR/"
              for resource in res lang; do
                ln -sfn "$1/share/bodyslide/$resource" "$BODYSLIDE_DATA_DIR/$resource"
              done
              for program in BodySlide OutfitStudio; do
                ln -sfn "$1/bin/$program" "$BODYSLIDE_DATA_DIR/$program"
              done
              for directory in SliderSets Automations PoseData RefTemplates ShapeData \
                SliderCategories SliderGroups SliderPresets RefNormals; do
                mkdir -p "$BODYSLIDE_DATA_DIR/$directory"
              done

              package="$1"
              program="$2"
              shift 2
              exec "$package/libexec/bodyslide/$program" "$@"
            '';
          };
        in
        stdenv.mkDerivation (finalAttrs: {
          pname = "bodyslide";
          version = "5.9.1";

          src = fetchFromGitHub {
            owner = "ousnius";
            repo = "BodySlide-and-Outfit-Studio";
            tag = "v${finalAttrs.version}";
            fetchSubmodules = true;
            hash = "sha256-YjpQQstiEa1CsBT6bunRWsKzGeUqY5htpacc6bsY/Wc=";
          };

          strictDeps = true;

          nativeBuildInputs = [
            cmake
            ninja
            pkg-config
            copyDesktopItems
            wrapGAppsHook3
            makeWrapper
          ];

          buildInputs = [
            gtk3
            wxwidgets_3_2
            libGL
            libGLU
            glew
            directx-headers
            bullet
            openexr
            imath
          ];

          cmakeFlags = [
            (lib.cmakeBool "BSOS_ENABLE_FBXSDK" false)
            (lib.cmakeBool "BSOS_ENABLE_BULLET" true)
            (lib.cmakeBool "BSOS_ENABLE_OPENEXR" true)
            (lib.cmakeBool "BSOS_BUILD_TESTS" false)
            (lib.cmakeFeature "wxWidgets_CONFIG_EXECUTABLE" "${lib.getBin wxwidgets_3_2}/bin/wx-config")
          ];

          postPatch = ''
            # Upstream uses a portable layout for resources, settings and
            # projects. Point both applications at the writable user layout.
            substituteInPlace src/program/BodySlideApp.cpp src/program/OutfitStudio.cpp \
              --replace-fail \
                'std::string dataDir{wxFileName(wxStandardPaths::Get().GetExecutablePath()).GetPath().ToUTF8()};' \
                'wxString dataPath; wxGetEnv("BODYSLIDE_DATA_DIR", &dataPath); std::string dataDir{dataPath.ToUTF8()};'
          '';

          ninjaFlags = [
            "BodySlide"
            "OutfitStudio"
          ];

          desktopItems = [
            (makeDesktopItem {
              name = "bodyslide";
              desktopName = "BodySlide";
              genericName = "Body and Outfit Generator";
              exec = "BodySlide";
              icon = "bodyslide";
              categories = [ "Graphics" ];
              terminal = false;
            })

            (makeDesktopItem {
              name = "outfitstudio";
              desktopName = "Outfit Studio";
              genericName = "Outfit and Mesh Editor";
              exec = "OutfitStudio";
              icon = "outfitstudio";
              categories = [ "Graphics" ];
              terminal = false;
            })
          ];

          installPhase = ''
            runHook preInstall

            mkdir -p "$out/bin" "$out/share/bodyslide"
            cp -r ../res ../lang ../*.xml "$out/share/bodyslide/"

            for program in BodySlide OutfitStudio; do
              install -Dm755 "$program" "$out/libexec/bodyslide/$program"
              makeWrapper ${lib.getExe launcher} "$out/bin/$program" \
                --add-flags "$out $program"
            done

            install -Dm644 ../res/images/BodySlide.png \
              "$out/share/icons/hicolor/256x256/apps/bodyslide.png"
            install -Dm644 ../res/images/OutfitStudio.png \
              "$out/share/icons/hicolor/256x256/apps/outfitstudio.png"

            runHook postInstall
          '';

          meta = {
            description = "BodySlide and Outfit Studio mesh and outfit editing tools";
            homepage = "https://github.com/ousnius/BodySlide-and-Outfit-Studio";
            changelog = "https://github.com/ousnius/BodySlide-and-Outfit-Studio/releases/tag/v${finalAttrs.version}";
            license = lib.licenses.gpl3Only;
            platforms = [ "x86_64-linux" ];
            mainProgram = "BodySlide";
          };
        })
      ) { };
    };

  flake.modules.nixos.bodyslide =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bodyslide
      ];
    };

  flake.modules.homeManager.bodyslide =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bodyslide
      ];
    };
}
