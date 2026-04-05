{
  flake.modules.homeManager.anki =
    {
      pkgs,
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
            usernameFile = "/run/secrets/anki_username";
            keyFile = "/run/secrets/anki_syncKey";
          };
        };
      };
    };
}
