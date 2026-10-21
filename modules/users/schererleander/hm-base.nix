{
  flake.modules.homeManager.schererleander-base =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        gpg
        git
        github
        zsh
        neovim
        zed
        lsp
        # TODO: Re-enable sioyek once nixpkgs fixes the Darwin mupdf linker path.
        spotify
        discord
        latex
        codex
        claude-code
      ];

      home = {
        file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";

        username = "schererleander";
        stateVersion = "26.05";
        packages = with pkgs; [
          obsidian
          jetbrains.datagrip
          jetbrains.idea
          jetbrains.clion
          jetbrains.webstorm
        ];
      };
    };
}
