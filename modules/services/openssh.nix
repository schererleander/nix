{
  flake.modules.nixos.openssh =
    {
      lib,
      pkgs,
      ...
    }:
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

      security.pam.services.sshd.text = lib.mkDefault (
        lib.mkAfter ''
          session optional pam_exec.so ${pkgs.writeShellScript "ssh-login-notify" ''
            if [ "$PAM_TYPE" = "open_session" ]; then
              TIMESTAMP=$(${pkgs.coreutils}/bin/date "+%Y-%m-%d %H:%M:%S %Z")
              HOSTNAME=$(${pkgs.coreutils}/bin/cat /etc/hostname)
              
              (
                ${pkgs.coreutils}/bin/echo "To: leander@schererleander.de"
                ${pkgs.coreutils}/bin/echo "From: root@sachiel.schererleander.de"
                ${pkgs.coreutils}/bin/echo "Subject: SSH Login Alert: $PAM_USER"
                ${pkgs.coreutils}/bin/echo "Content-Type: text/html; charset=UTF-8"
                ${pkgs.coreutils}/bin/echo ""
                ${pkgs.coreutils}/bin/cat <<EOF
              <!DOCTYPE html>
              <html>
              <head>
              <meta name="color-scheme" content="light dark">
              <style>
                :root { color-scheme: light dark; }
                body { font-family: sans-serif; line-height: 1.5; color: #000; background: #fff; max-width: 800px; margin: 0 auto; padding: 20px; }
                h1 { border-bottom: 2px solid #000; color: #d97706; }
                table { width: 100%; border-collapse: collapse; margin-bottom: 15px; font-size: 13px; }
                th, td { text-align: left; padding: 6px; border-bottom: 1px solid #ddd; }
                a { color: #0066cc; }
                @media (prefers-color-scheme: dark) {
                  body { background: #121212; color: #eee; }
                  h1, th { border-color: #555; }
                  h1 { color: #f59e0b; }
                  th, td { border-color: #333; }
                  a { color: #66b3ff; }
                }
              </style>
              </head>
              <body>
                <h1>SSH Login Alert</h1>
                
                <p>A successful SSH login was just detected.</p>

                <table>
                  <tr><th>User</th><td>$PAM_USER</td></tr>
                  <tr><th>Host</th><td>$HOSTNAME</td></tr>
                  <tr><th>Time</th><td>$TIMESTAMP</td></tr>
                  <tr><th>IP Address</th><td><a href="https://iplookup.flagfox.net/?ip=$PAM_RHOST">$PAM_RHOST</a></td></tr>
                  <tr><th>Service</th><td>$PAM_SERVICE</td></tr>
                  <tr><th>TTY</th><td>$PAM_TTY</td></tr>
                </table>
              </body>
              </html>
EOF
              ) | /run/wrappers/bin/sendmail -f root@sachiel.schererleander.de leander@schererleander.de
            fi
          ''}
        ''
      );
    };
}
