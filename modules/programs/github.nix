{
  flake.modules.homeManager.github = { pkgs, ... }: {
    programs.gh = {
      enable = true;
      settings = {
        editor = "nvim";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
      gitCredentialHelper = {
        enable = true;
        hosts = [
          "https://github.com"
          "https://gist.github.com"
        ];
      };
      extensions = with pkgs; [
        gh-dash
      ];
    };
  };
}
