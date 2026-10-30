{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.anki-mcp = pkgs.buildNpmPackage (finalAttrs: {
        pname = "anki-mcp";
        version = "0.2.0";

        src = pkgs.fetchFromGitHub {
          owner = "nietus";
          repo = "anki-mcp";
          tag = "v${finalAttrs.version}";
          hash = "sha256-GFOnUa4um7Br6G19sNdO5z8TqRso0V3A5OpH6P4OdAw=";
        };

        nodejs = pkgs.nodejs_22;

        npmDepsHash = "sha256-cPKV6e/NbUDzKYDQp+AgG9z9VHkWBiq/rJvfyk0nJLU=";

        # The release lockfile pins Node 20 typings despite Vitest's newer peer requirement.
        npmFlags = [ "--legacy-peer-deps" ];

        npmBuildScript = "build";

        meta = {
          description = "Local Anki MCP server using AnkiConnect";
          homepage = "https://github.com/nietus/anki-mcp";
          license = pkgs.lib.licenses.mit;
          mainProgram = "anki-mcp";
          platforms = pkgs.nodejs_22.meta.platforms;
        };
      });
    };
}
