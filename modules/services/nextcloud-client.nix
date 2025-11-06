{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  options.nx.services.nextcloud-client.enable =
    lib.mkEnableOption "Enable and setup nextcloud-client";
  config = lib.mkIf config.nx.services.nextcloud-client.enable {
    home-manager.users."${username}" = {
      home.packages = with pkgs; [ nextcloud-client ];
      services.nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };
  };
}
