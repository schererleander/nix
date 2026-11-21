{
  flake.modules.homeManager.schererleander-linux =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        firefox
        mpv
        vlc
        nextcloud-client
        jellyfin-desktop
        libreoffice
        wine
        mcp
        minecraft
        emulators
      ];

      home = {
        homeDirectory = "/home/schererleander";
        packages = with pkgs; [
          chatgpt
          hytale-launcher
          loot
          renderdoc
        ];
      };
    };
}
