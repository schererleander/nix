{
  flake.modules.homeManager.schererleander-darwin =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
      ];

      home.packages = with pkgs; [
        moonlight-qt
      ];

      home.homeDirectory = "/Users/schererleander";
    };
}
