{
  flake.modules.nixos.openssh =
    { lib, pkgs, ... }:
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
        jails.sshd = {
          enabled = true;
          settings = {
            port = 8693;
            backend = "systemd";
            maxretry = 4;
            findtime = "10m";
          };
        };
      };

      security.pam.services.sshd.text = lib.mkDefault (
        lib.mkAfter ''
          session optional pam_exec.so ${pkgs.writeShellScript "ssh-login-notify" ''
            if [ "$PAM_TYPE" = "open_session" ]; then
              TIMESTAMP=$(${pkgs.coreutils}/bin/date "+%Y-%m-%d %H:%M:%S %Z")
              HOSTNAME=$(${pkgs.coreutils}/bin/cat /etc/hostname)

              {
                ${pkgs.coreutils}/bin/printf '%s\n' \
                  "To: leander@schererleander.de" \
                  "From: root@sachiel.schererleander.de" \
                  "Subject: SSH login: $PAM_USER from $PAM_RHOST" \
                  "Content-Type: text/html; charset=UTF-8" \
                  ""

                ${pkgs.coreutils}/bin/cat <<EOF
                <!doctype html>
                <html>
                  <head>
                    <meta name="color-scheme" content="light dark">
                    <meta name="supported-color-schemes" content="light dark">
                    <style>
                      :root { color-scheme: light dark; }
                      body { margin: 0; padding: 20px; font: 14px sans-serif; background: #fff; color: #111; }
                      main { max-width: 600px; margin: auto; }
                      h1 { margin-top: 0; font-size: 22px; }
                      table { width: 100%; border-collapse: collapse; }
                      th, td { padding: 6px; text-align: left; border-bottom: 1px solid #ddd; }
                      th { width: 80px; }
                      a { color: #06c; }

                      @media (prefers-color-scheme: dark) {
                        body { background: #121212; color: #eee; }
                        th, td { border-color: #333; }
                        a { color: #6bf; }
                      }
                    </style>
                  </head>
                  <body>
                    <main>
                      <h1>SSH Login</h1>
                      <table>
                        <tr><th>User</th><td>$PAM_USER</td></tr>
                        <tr><th>Host</th><td>$HOSTNAME</td></tr>
                        <tr><th>Time</th><td>$TIMESTAMP</td></tr>
                        <tr>
                          <th>IP</th>
                          <td>
                            <a href="https://iplookup.flagfox.net/?ip=$PAM_RHOST">$PAM_RHOST</a>
                          </td>
                        </tr>
                      </table>
                    </main>
                  </body>
                </html>
EOF
              } | /run/wrappers/bin/sendmail \
                -f root@sachiel.schererleander.de \
                leander@schererleander.de
            fi
          ''}
        ''
      );
    };
}
