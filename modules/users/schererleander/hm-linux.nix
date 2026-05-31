{
  flake.modules.homeManager.schererleander-linux =
    { inputs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        firefox
        anki
        nextcloud-client
        vlc
        jellyfin-mpv-shim
        libreoffice
      ];
    };
}
