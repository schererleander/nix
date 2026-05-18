{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
          Privacy = "device";
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };
}
