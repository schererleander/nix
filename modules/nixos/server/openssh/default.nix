{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nx.server.openssh;
in
{
  options.nx.server.openssh = {
    enable = mkEnableOption "OpenSSH server";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 8693 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = [ ];
        X11Forwarding = false;
        PermitRootLogin = "yes";
      };
    };
    networking.firewall.allowedTCPPorts = [ 8693 ];

    services.fail2ban = {
      enable = true;
      bantime = "1h";
      jails = {
        sshd = {
          enabled = true;
          settings = {
            port = 8693;
            backend = "systemd";
            maxretry = 4;
            findtime = "10m";
          };
        };
      };
    };
  };
}
