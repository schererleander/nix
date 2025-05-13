{ config, lib, pkgs, ... }:

{
  options.zsh.enable = lib.mkEnableOption "Configure zsh";
  config = lib.mkIf config.zsh.enable {
    home.packages = with pkgs; [
      zoxide
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        # view man pages with nvim
        export MANPAGER="nvim +Man!"

        # Directory completion with trailing slash
        zstyle ':completion:*' list-dirs-first true
        zstyle ':completion:*' special-dirs true
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' add-space false

        # Case-insensitive completion
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

        # vim keybindings
        bindkey -v

        eval "$(zoxide init zsh)"
      '';

      shellAliases = {
        ls = "ls --color=auto";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "mafredri/zsh-async"; }
          { name = "sindresorhus/pure"; tags = [ "as:theme" "use:pure.zsh" ]; }
          { name = "zdharma-continuum/fast-syntax-highlighting"; }
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };
    };
  };
}
