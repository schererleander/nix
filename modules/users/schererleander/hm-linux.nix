{
  flake.modules.homeManager.schererleander-linux =
    { inputs, pkgs, ... }:
    {
      home.packages = with pkgs; [
        jellyfin-desktop
      ];

      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        sway
        firefox
        anki
        nextcloud-client
        vlc
      ];
    };
}
