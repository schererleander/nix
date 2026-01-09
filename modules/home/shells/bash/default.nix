{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.shells.bash;
in
{
  options.nx.shells.bash = {
    enable = mkEnableOption "bash shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide
    ];

    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        # view man pages with nvim
        export MANPAGER="nvim +Man!"

        # vim keybindings
        set -o vi

        # zoxide smarter cd command
        eval "$(zoxide init bash)"
      '';
      shellAliases = {
        ls = "ls --color=auto";
      };
    };
  };
}
