# Package overlay review

Reviewed 2026-11-13 against the inputs in `flake.lock`: stable
`ac588ef1c914865dad517b337ea0eb9694a4021c` and unstable
`2074cc672349f14240fb7ea90d509e0b643e9dd4`.

`modules/overlays/unstable.nix` imports a complete unstable package set so
applications keep matching dependencies. The remaining local derivations live
in `pkgs/` and are registered by `modules/overlays/packages.nix`.

| Package | Decision |
| --- | --- |
| Codex | Use unstable 0.167.1 instead of the custom 0.160.0 build. Upstream includes the package layout, resources and V8 integration. |
| Claude Code | Replace the 2.1.318 manifest override with unstable 2.1.322. |
| ChatGPT | Keep unstable: stable only supports Darwin, while unstable also supports Linux. |
| Wootility | Keep unstable 5.4.2 instead of stable 5.3.1, on Linux only. |
| Anki | Keep stable on Linux and unstable on Darwin, with the macOS helper version-hook workaround. Keep Qt and Python dependencies in the same package set. |
| RenderDoc with Python | Keep the stable override that installs `renderdoc.so`, matching the MCP server's Python 3.12. Unstable 1.47 explicitly disables Python bindings. |
| ffdecmcp | Keep local; stable FastMCP still needs the three proxy test exclusions. |
| BodySlide, Hytale Launcher, IDA Pro, IDA MCP, LOOT, OpenGOAL Launcher, RenderDoc MCP, Claude Desktop | Keep local: no direct package or matching upstream project was found in the locked unstable source tree. |

Revisit these decisions when updating the lock file. In particular, remove the
Anki workaround once upstream stops running `pyprojectVersionPatchHook` when
the bundled helper version already matches.

Upstream source at the reviewed revision:
[Codex](https://github.com/NixOS/nixpkgs/blob/2074cc672349f14240fb7ea90d509e0b643e9dd4/pkgs/by-name/co/codex/package.nix),
[Claude Code manifest](https://github.com/NixOS/nixpkgs/blob/2074cc672349f14240fb7ea90d509e0b643e9dd4/pkgs/by-name/cl/claude-code/manifest.zst.json),
[Anki helper](https://github.com/NixOS/nixpkgs/blob/2074cc672349f14240fb7ea90d509e0b643e9dd4/pkgs/development/python-modules/anki-mac-helper/default.nix),
[RenderDoc](https://github.com/NixOS/nixpkgs/blob/2074cc672349f14240fb7ea90d509e0b643e9dd4/pkgs/by-name/re/renderdoc/package.nix).
