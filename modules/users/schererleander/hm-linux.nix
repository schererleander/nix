{
  flake.modules.homeManager.schererleander-linux =
    { inputs, ... }:
    {
      imports = [
        inputs.self.modules.homeManager.schererleander-base
        inputs.self.modules.homeManager.opencode
        inputs.self.modules.homeManager.nixcord
        inputs.self.modules.homeManager.spicetify
        inputs.self.modules.homeManager.jellyfin-mpv-shim
        inputs.self.modules.homeManager.nextcloud-client
      ];
    };
}
