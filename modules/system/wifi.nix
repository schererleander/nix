{
  flake.modules.nixos.wifi = {
    networking.networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    boot.extraModprobeConfig = ''
      options mt7921e disable_aspm=1
    '';
  };
}
