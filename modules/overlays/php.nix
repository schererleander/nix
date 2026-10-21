{
  flake.overlays.php =
    _final: prev:
    let
      # CVE-2026-109618 and CVE-2026-109619, released 2026-10-21.
      # https://www.php.net/archive/2026.php#2026-10-21-1
      # SHA-256 checksums for the official tar.bz2 source archives.
      releases = {
        php82 = {
          version = "8.2.35";
          hash = "sha256-D0Pv0awk1PkAAsjU1XC/TE1Z+hQxO/JwqujPBNnf3vM=";
        };
        php83 = {
          version = "8.3.36";
          hash = "sha256-RvS0XjaI7SsYGQFae1MsFbUcwFW907E/0A3f7r7tzV8=";
        };
        php84 = {
          version = "8.4.27";
          hash = "sha256-slMKh3xyL0sIyeF0owywi6wrfhkD7m6eMV8KqfX4LCQ=";
        };
        php85 = {
          version = "8.5.12";
          hash = "sha256-/7YO3EN87WO1E35JhNs3moERxQBJxxFRDYuVgnfvwag=";
        };
      };
    in
    prev.lib.mapAttrs (
      name: release:
      # Let nixpkgs take over once it has this release or a newer one.
      if prev.lib.versionAtLeast prev.${name}.version release.version then
        prev.${name}
      else
        let
          updated = prev.${name}.override (args: {
            inherit (release) version hash;
            packageOverrides = prev.lib.composeExtensions (args.packageOverrides or (_: _: { })) (
              _finalPackages: prevPackages: {
                extensions = prevPackages.extensions // {
                  filter = prevPackages.extensions.filter.overrideAttrs (old: {
                    # These tests start php-cgi with -n. Nix builds filter as a
                    # shared extension, so the child CGI must load it explicitly.
                    postPatch = (old.postPatch or "") + ''
                      for test in oom_filter_default_encoded oom_filter_input oom_filter_input_array; do
                        substituteInPlace "ext/filter/tests/$test.phpt" \
                          --replace-fail "'-n'," "'-n', '-d', 'extension=' . __DIR__ . '/../modules/filter.so',"
                      done
                    '';
                  });
                };
              }
            );
          });
        in
        # Recreate PHP's buildEnv scope so it captures packageOverrides too.
        updated.overrideAttrs (_: { })
    ) releases;
}
