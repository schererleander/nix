{ config, lib, pkgs, ... }:

let
  cfg = config.zsh;
in {
  options.zsh.enable = lib.mkEnableOption "Enable zsh and configure";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    plugins = [
        {
          name = "pure";
          src = "${pkgs.pure-prompt}/share/zsh/site-functions";
        }
        {
          name = "zsh-completions";
          src = "${pkgs.zsh-completions}/share/zsh/site-functions";
        }
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
      ];
    };
  };
}
