{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.hardware.bluetooth;
in
{
  options.nx.hardware.bluetooth.enable = mkEnableOption "Bluetooth support";

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };
}
