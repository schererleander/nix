{
  flake.modules.homeManager.schererleander-linux =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        sway
        firefox
        anki
        nextcloud-client
        vlc
        ghostty
        jellyfin-mpv-shim
      ];
    };
}
