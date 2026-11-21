{
  flake.modules.homeManager.zsh =
    { pkgs, ... }:
    {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      home.sessionVariables.MANPAGER = "nvim +Man!";

      programs.zsh = {
        autocd = true;
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

          # Directory completion with trailing slash
          zstyle ':completion:*' list-dirs-first true
          zstyle ':completion:*' special-dirs true
          zstyle ':completion:*' squeeze-slashes true
          zstyle ':completion:*' add-space false

          # Case-insensitive completion
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

          setopt AUTO_PARAM_SLASH
        '';
        shellAliases = {
          ls = "ls --color=auto";
        };
      };
    };
}
