{ ... }:
{
  flake.overlays.codex = final: prev: {
    codex = prev.codex.override {
      rustPlatform = prev.rustPlatform // {
        buildRustPackage = attrs:
          prev.rustPlatform.buildRustPackage (
            finalAttrs:
            (attrs finalAttrs)
            // {
              version = "0.153.4";

              src = final.fetchFromGitHub {
                owner = "openai";
                repo = "codex";
                tag = "rust-v${finalAttrs.version}";
                hash = "sha256-lHiDj5SodaM3mh8goMm6esfejeAT+Y3JJWrRnyj6sJo=";
              };

              cargoHash = "sha256-GG6kOXmCdq+bZLU2ul0DIVL8lDuweayvZvXn6+bcUZw=";
            }
          );
      };
    };
  };
}
