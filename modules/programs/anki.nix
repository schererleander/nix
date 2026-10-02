{
  flake.modules.homeManager.anki = {
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
      # TODO: Re-enable review-heatmap once the PyQt5 build's SIP ABI mismatch is fixed.
    };
  };
}
