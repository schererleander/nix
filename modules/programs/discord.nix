{
  flake.modules.homeManager.discord = {
    programs.vesktop = {
      enable = true;
      vencord = {
        useSystem = true;
        # Nitro ad removal (https://github.com/croissantdunord/discord-adblock).
        extraQuickCss = ''
          @import url(https://croissantdunord.github.io/discord-adblock/adblock.css);
          @import url(https://croissantdunord.github.io/discord-adblock/adblock-extras.css);
        '';
      };
    };
  };
}
