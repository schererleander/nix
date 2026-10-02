{
  flake.modules.homeManager.schererleander-base =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        gpg
        git
        zsh
        neovim
        zed
        lsp
        # TODO: Re-enable sioyek once nixpkgs fixes the Darwin mupdf linker path.
        # sioyek
        spotify
        discord
        latex
        codex
        claude-code
      ];

      # Allow search or installation for unfree packages as a user
      home = {
        file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";

        username = "schererleander";
        stateVersion = "26.05";
        packages = with pkgs; [
          obsidian
        ];
      };
    };
}
