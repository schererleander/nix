{
  config,
  lib,
  username,
  ...
}:

{
  options.nextcloud-client.enable = lib.mkEnableOption "Enable and setup nextcloud-client";
  config = lib.mkIf config.nextcloud-client.enable {
    home-manager.users."${username}".services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
