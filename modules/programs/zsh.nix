{
  flake.modules.homeManager.zsh =
    { pkgs, ... }:
    {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "pure";
            src = "${pkgs.pure-prompt}/share/zsh/site-functions";
          }
        ];
        initContent = ''
          autoload -U promptinit
          promptinit
          prompt pure

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

          # Auto cd - type directory name to cd into it
          setopt AUTO_CD

          # Complete .. to ../ for directory navigation
          setopt AUTO_PARAM_SLASH
        '';
        shellAliases = {
          ls = "ls --color=auto";
        };
      };
    };
}
