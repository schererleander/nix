{
  flake.modules.darwin.home-manager =
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.darwinModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.schererleander = inputs.self.modules.homeManager.schererleander;
      };
    };
}
