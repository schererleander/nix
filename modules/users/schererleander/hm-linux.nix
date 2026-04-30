{
  flake.modules.homeManager.schererleander-linux =
    { inputs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        sway
        firefox
        anki
        jellyfin-mpv-shim
        nextcloud-client
        vlc
      ];
    };
}
