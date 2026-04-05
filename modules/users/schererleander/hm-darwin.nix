{
  flake.modules.homeManager.schererleander-darwin =
    { inputs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        schererleander-base
      ];
    };
}
