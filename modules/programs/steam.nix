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
        ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event[0-9]*", ATTRS{id/vendor}=="054c", ATTRS{id/product}=="0ce6", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
    };
}
