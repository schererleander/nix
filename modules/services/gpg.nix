{
  flake.modules.homeManager.gpg =
    {
      pkgs,
      ...
    }:
    {
      programs.gpg = {
        enable = true;
      };

      services.gpg-agent = {
        enable = true;
        pinentry.package =
          if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-qt;
      };
    };
}
