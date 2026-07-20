{
  flake.modules.homeManager.schererleander-linux =
    { inputs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        firefox
        anki
        mpv
        nextcloud-client
        jellyfin-desktop
        libreoffice
        wine
        mcp
        opencode
        open-goal-launcher
        minecraft
        emulators
      ];
    };
}
