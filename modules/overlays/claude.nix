{
  # TODO: Pin release hashes for the remaining platforms; keep upstream packages until then.
  flake.overlays.claude-code =
    _final: prev:
    prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-linux") {
      claude-code = prev.claude-code.override {
        manifest = {
          version = "2.1.282";

          platforms = {
            "linux-x64" = {
              binary = "claude.zst";
              checksum = "sha256-Ov6FNcDMM/DiT3sl2rehcnuLWSGW+Elqi8MCuiFh7tM=";
            };
          };
        };
      };
    };
}
