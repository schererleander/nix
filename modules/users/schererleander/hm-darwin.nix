{
  flake.modules.homeManager.schererleander-darwin =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
      ];

      programs.java = {
        enable = true;
        package = pkgs.jdk21;
      };

      home.packages = with pkgs; [
        appcleaner
        chatgpt
        claude-desktop
        iterm2
        moonlight-qt
        rectangle
        wireshark
      ];

      home.homeDirectory = "/Users/schererleander";
    };
}
