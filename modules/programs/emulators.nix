{
  flake.modules.homeManager.emulators = { pkgs, ... }: {
    home.packages = with pkgs; [
      steam-rom-manager
      pcsx2
      # TODO: Re-enable rpcs3.
      # rpcs3
      ryubing
      shipwright
      dusklight
    ];
  };
}
