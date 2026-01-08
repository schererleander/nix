{
  config,
  username,
  pkgs,
  lib,
  ...
}:

{
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
      (lib.mkIf config.networking.networkmanager.enable "networkmanager")
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  security.sudo.wheelNeedsPassword = false;
}
