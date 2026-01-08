{
  config,
  lib,
  ...
}:
let
  cfg = config.nx.git;
  inherit (lib) mkOption mkIf types;
in
{
  options.nx.git = {
    enable = mkOption {
      description = "Enable git";
      type = types.bool;
      default = false;
    };

    userName = mkOption {
      description = "Git username";
      type = types.str;
      default = "Leander Scherer";
    };

    userEmail = mkOption {
      description = "Git email";
      type = types.str;
      default = "leander@schererleander.de";
    };

    signKey = mkOption {
      description = "Sign key";
      type = types.nullOr types.str;
      default = "A3502B180BC1D41A";
    };

    signFlavor = mkOption {
      description = "Sign key flavor";
      type = types.enum [
        "ssh"
        "openpgp"
      ];
      default = "openpgp";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      signing = mkIf (cfg.signKey != null) {
        key = cfg.signKey;
        signByDefault = true;
      };

      ignores = [
        "*~"
        ".DS_Store"
        ".direnv"
        ".envrc"
      ];

      settings = {
        user.name = cfg.userName;
        user.email = cfg.userEmail;
        help.autocorrect = 20;
        alias = {
          st = "status";
          co = "checkout";
          br = "branch";
        };
        pull.rebase = true;
        gpg.format = cfg.signFlavor;
        url."git@github.com:".insteadOf = "https://github.com";
      };
    };
    programs.diff-highlight = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
