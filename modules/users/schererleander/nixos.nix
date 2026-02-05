{
  flake.modules.nixos.home-manager =
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.schererleander = inputs.self.modules.homeManager.schererleander;
      };
    };
}
