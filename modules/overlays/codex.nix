{ ... }:
{
  flake.overlays.codex =
    final: prev:
    let
      system = final.stdenv.hostPlatform.system;
      rustTarget = final.stdenv.hostPlatform.rust.rustcTarget;

      rustyV8Archive = final.fetchurl {
        name = "librusty_v8-150.4.0";
        url = "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/librusty_v8_release_${rustTarget}.a.gz";
        sha256 =
          {
            x86_64-linux = "0v5hi3s56b6yk7nh5n0wygh7fn0j41yyjz5903r227qv0yvzssaq";
            aarch64-linux = "1lvx9xjzv7ibqvg5jnaxqaaim0lw4dwfgf6kw0pjfdrkmm97s5xp";
            aarch64-darwin = "043bgs3hcvrn1yzknrxchqnki8r9p7ggk9zbiaqwa8mqhlagin6c";
          }
          .${system};
      };

      rustyV8SrcBinding = final.fetchurl {
        name = "src_binding-150.4.0";
        url = "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/src_binding_release_${rustTarget}.rs";
        sha256 =
          {
            x86_64-linux = "01l53l6nk4p5brpz2v3svqijx3hz5nqry8q7x12vdgbrwim849vp";
            aarch64-linux = "01l53l6nk4p5brpz2v3svqijx3hz5nqry8q7x12vdgbrwim849vp";
            aarch64-darwin = "0krrb2vh4skvfmzwpcqkl55bg2gyn943drqa8snp16lwz06dynna";
          }
          .${system};
      };
    in
    {
      codex =
        let
          unbundled = prev.codex.override {
            rustPlatform = prev.rustPlatform // {
              buildRustPackage =
                attrs:
                prev.rustPlatform.buildRustPackage (
                  finalAttrs:
                  let
                    originalAttrs = attrs finalAttrs;
                    originalDepsExtraArgs = originalAttrs.depsExtraArgs or { };
                    originalEnv = originalAttrs.env or { };
                  in
                  originalAttrs
                  // {
                    version = "0.160.0";

                    src = final.fetchFromGitHub {
                      owner = "openai";
                      repo = "codex";
                      tag = "rust-v${finalAttrs.version}";
                      hash = "sha256-UFPv9UK0MBYZfpZ3QlkTXa19ykHwIEo3JdwPtUUrJls=";
                    };

                    cargoHash = "sha256-DMRbIOynO0wGXjBxaXZJNKorD9YQv3fAoRTZ4iZEIE4=";

                    env = originalEnv // {
                      RUSTY_V8_ARCHIVE = rustyV8Archive;
                      RUSTY_V8_SRC_BINDING_PATH = rustyV8SrcBinding;
                    };

                    postPatch = (originalAttrs.postPatch or "") + ''
                      sed -i '1i#![recursion_limit = "256"]' chatgpt/src/lib.rs
                    '';

                    depsExtraArgs = originalDepsExtraArgs // {
                      env = (originalDepsExtraArgs.env or { }) // {
                        GIT_CONFIG_COUNT = "1";
                        GIT_CONFIG_KEY_0 = "http.version";
                        GIT_CONFIG_VALUE_0 = "HTTP/1.1";
                      };
                    };
                  }
                );
            };
          };
        in
        final.runCommand "codex-${unbundled.version}"
          {
            inherit (unbundled) version meta;
            passthru = (unbundled.passthru or { }) // {
              inherit unbundled;
            };
          }
          ''
            mkdir -p "$out"
            cp -rL ${unbundled}/. "$out/"
            chmod -R u+w "$out"
            mv "$out/bin/.codex-wrapped" "$out/bin/codex"

            mkdir -p "$out/codex-path" "$out/codex-resources"
            install -m755 ${final.ripgrep}/bin/rg "$out/codex-path/rg"
            ${final.lib.optionalString final.stdenv.hostPlatform.isLinux ''
              install -m755 ${final.bubblewrap}/bin/bwrap "$out/codex-resources/bwrap"
            ''}

            cat > "$out/codex-package.json" <<'EOF'
            ${builtins.toJSON {
              layoutVersion = 1;
              version = unbundled.version;
              target = rustTarget;
              variant = "codex";
              entrypoint = "bin/codex";
              resourcesDir = "codex-resources";
              pathDir = "codex-path";
            }}
            EOF
          '';
    };
}
