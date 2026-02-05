{
  flake.modules.homeManager.schererleander =
    { inputs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        gpg
        git
        zsh
        opencode
        neovim
        zed
        nixcord
        spicetify
        obsidian
      ];

      home = {
        username = "schererleander";
        stateVersion = "26.05";
      };
    };
}
