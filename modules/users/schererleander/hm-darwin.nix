{
  flake.modules.homeManager.schererleander-darwin =
    { inputs, ... }:
    {
      imports = [
        inputs.self.modules.homeManager.schererleander-base
      ];
    };
}
