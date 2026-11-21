{
  flake.modules.homeManager.schererleander-darwin =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
        iterm2
      ];

      programs.java = {
        enable = true;
        package = pkgs.jdk21;
      };

      home.packages = with pkgs; [
        appcleaner
        chatgpt
        claude-desktop
        moonlight-qt
        rectangle
        wireshark
      ];

      home.homeDirectory = "/Users/schererleander";
    };
}
