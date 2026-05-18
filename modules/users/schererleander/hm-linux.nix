{
  flake.modules.homeManager.schererleander-linux =
    { inputs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        sway
        quickshell
        firefox
        anki
        nextcloud-client
        vlc
        ghostty
        jellyfin-mpv-shim
      ];
    };
}
