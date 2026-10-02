{
  flake.modules.nixos.openssh =
    { config, lib, ... }:
    {
      services.openssh = {
        enable = true;
        ports = [ 8693 ];
        settings = {
          AllowTcpForwarding = false;
          AllowAgentForwarding = false;
          PasswordAuthentication = false;
          X11Forwarding = false;
          PermitRootLogin = "yes";
        };
      };

      services.fail2ban = {
        enable = true;
        bantime = lib.mkDefault "1h";
        jails.sshd = {
          enabled = true;
          settings = {
            port = lib.concatMapStringsSep "," toString config.services.openssh.ports;
            backend = "systemd";
            maxretry = 4;
            findtime = "10m";
          };
        };
      };
    };
}
