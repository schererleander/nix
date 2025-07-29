self: super: {
  vencord = super.vencord.overrideAttrs (old: rec {
    pname = "vencord";
    version = "1.12.7";

    src = super.fetchFromGitHub {
      owner = "Vencord";
      repo = "Vencord";
      rev = "v${version}";
      sha256 = "sha256-NEW_HASH_FROM_BUILD";
    };

    pnpmDeps = super.fetchPnpmDeps {
      inherit src;
      lockfile = "${src}/pnpm-lock.yaml";
      sha256 = "sha256-QiD4qTRtz5vz0EEc6Q08ej6dbVGMlPLU2v0GVKNBQyc="; # ← from error message
    };

    nativeBuildInputs = old.nativeBuildInputs ++ [ super.nodejs ];
  });
}
