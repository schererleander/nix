{
  config,
  username,
  pkgs,
  lib,
  ...
}:

{
  options.nx.programs.typst.enable = lib.mkEnableOption "Setup typst";
  config = lib.mkIf config.nx.programs.typst.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        typst
        typst-fmt
      ];
    };
  };
}