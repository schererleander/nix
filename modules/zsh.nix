{ config, lib, pkgs, ... }:

let
  cfg = config.zsh;
in {
  options.zsh.enable = lib.mkEnableOption "Configure zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        # Directory completion with trailing slash
        zstyle ':completion:*' list-dirs-first true
        zstyle ':completion:*' special-dirs true
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' add-space false
      '';

      zplug = {
        enable = true;
        plugins = [
          { name = "mafredri/zsh-async"; }
          { name = "zpm-zsh/colorize"; }
          { name = "sindresorhus/pure"; tags = [ "as:theme" "use:pure.zsh" ]; }
          { name = "zdharma-continuum/fast-syntax-highlighting"; }
          { name = "agkozak/zsh-z"; }
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };
    };
  };
}
