{ ... }:
{
  flake.overlays.hcli = final: prev: {
    hcli = final.stdenv.mkDerivation rec {
      pname = "hcli";
      version = "0.18.1";

      src = final.fetchurl {
        url = "https://github.com/HexRaysSA/ida-hcli/releases/download/v${version}/hcli-linux-x86_64-${version}";
        hash = "sha256-l9Wql8exa0a6IOTpaJdJ749WI2+9v5+3IJe8kVAm7Tw=";
      };

      dontUnpack = true;

      nativeBuildInputs = [
        final.autoPatchelfHook
        final.makeWrapper
      ];

      buildInputs = [
        final.stdenv.cc.cc.lib
        final.zlib
        final.openssl
        final.libffi
        final.xz
        final.bzip2
      ];

      installPhase = ''
        runHook preInstall

        install -Dm755 "$src" "$out/bin/hcli-unwrapped"

        makeWrapper "$out/bin/hcli-unwrapped" "$out/bin/hcli" \
          --set-default HCLI_DISABLE_UPDATES true \
          --set-default HCLI_CURRENT_IDA_INSTALL_DIR "${final.ida-pro}/opt" \
          --set-default HCLI_CURRENT_IDA_PLATFORM "linux-x86_64" \
          --set-default HCLI_CURRENT_IDA_VERSION "${final.ida-pro.version}"

        runHook postInstall
      '';

      meta = with final.lib; {
        description = "Hex-Rays command-line interface";
        homepage = "https://github.com/HexRaysSA/ida-hcli";
        license = licenses.mit;
        mainProgram = "hcli";
        platforms = [ "x86_64-linux" ];
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      };
    };
  };

  flake.modules.nixos.hcli =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.hcli
      ];
    };

  flake.modules.homeManager.hcli =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.hcli
      ];
    };
}
