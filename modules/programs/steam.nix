{
  flake.modules.nixos.steam =
    {
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
      # Ignore the DualSense touchpad in libinput to prevent it from acting as a mouse
      services.udev.extraRules = ''
        ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="DualSense Wireless Controller", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="DualSense Wireless Controller Motion Sensors", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
    };
}
