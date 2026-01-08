{
  host,
  ...
}:

{
  networking = {
    hostName = host;
    networkmanager.enable = true;
  };

  # Improve startup time
  systemd.services.NetworkManager-wait-online.enable = false;
}
