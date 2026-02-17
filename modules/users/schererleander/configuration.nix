{
  flake.modules.homeManager.schererleander =
    { inputs, pkgs, ... }:
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
        jellyfin-mpv-shim
        nextcloud-client
      ];

      home = {
        username = "schererleander";
        stateVersion = "26.05";
        packages = with pkgs; [
          firefox
          obsidian
          tor-browser
          gohufont
        ];
      };
    };
}
