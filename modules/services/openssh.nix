{
  flake.modules.nixos.openssh =
    {
      lib,
      ...
    }:
    {
      services.openssh = {
        enable = true;
        ports = [ 8693 ];
        settings = {
          PasswordAuthentication = false;
          X11Forwarding = false;
          PermitRootLogin = "yes";
        };
      };
      networking.firewall.allowedTCPPorts = [ 8693 ];

      services.fail2ban = {
        enable = true;
        bantime = lib.mkDefault "1h";
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
