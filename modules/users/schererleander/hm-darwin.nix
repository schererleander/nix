{
  flake.modules.homeManager.schererleander-darwin =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
      ];

      home.packages = with pkgs; [
        chatgpt
        claude-desktop
        moonlight-qt
      ];

      home.homeDirectory = "/Users/schererleander";
    };
}
