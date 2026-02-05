{
  flake.modules.nixos.git =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        package = pkgs.git;
      };
    };

  flake.modules.homeManager.git =
    { ... }:
    {
      programs.git = {
        enable = true;

        signing = {
          key = "A3502B180BC1D41A";
          signByDefault = true;
        };

        ignores = [
          "*~"
          ".DS_Store"
          ".direnv"
          ".envrc"
        ];

        settings = {
          user.name = "Leander Scherer";
          user.email = "leander@schererleander.de";
          help.autocorrect = 20;
          alias = {
            st = "status";
            co = "checkout";
            br = "branch";
          };
          pull.rebase = true;
          gpg.format = "openpgp";
          url."git@github.com:".insteadOf = "https://github.com";
        };
      };
      programs.diff-highlight = {
        enable = true;
        enableGitIntegration = true;
      };
    };
}
