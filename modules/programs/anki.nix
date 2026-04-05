{
  flake.modules.homeManager.anki =
    {
      pkgs,
      config,
      osConfig,
      ...
    }:
    {
      programs.anki = {
        enable = true;
        style = "native";
        theme = "followSystem";
        profiles."User 1" = {
          sync = {
            autoSync = true;
            syncMedia = true;
            usernameFile = osConfig.sops.secrets.anki_username.path;
            keyFile = osConfig.sops.secrets.anki_syncKey.path;
          };
        };
        addons = with pkgs.ankiAddons; [
          review-heatmap
        ];
      };
    };
}
