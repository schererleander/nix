{
  flake.modules.homeManager.schererleander-base =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        gpg
        git
        zsh
        neovim
        zed
      ];

      home = {
        username = "schererleander";
        stateVersion = "26.05";
        packages = with pkgs; [
          firefox
          obsidian
        ];
      };
    };
}
