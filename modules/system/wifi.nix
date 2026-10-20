{
  flake.modules.nixos.wifi = {
    networking.networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
