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
        sioyek
        spicetify
        nixcord
      ];

      # Allow search or installation for unfree packages as a user
      home = {
        file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";

        username = "schererleander";
        stateVersion = "26.05";
        packages = with pkgs; [
          obsidian
          claude-code
          gemini-cli
        ];
      };
    };
}
