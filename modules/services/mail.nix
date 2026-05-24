{
  flake.modules.nixos.mail =
    { pkgs, ... }:
    {
      services.postfix = {
        enable = true;
        setSendmail = true;
        settings.main = {
          myhostname = "sachiel.schererleander.de";
          mydomain = "schererleander.de";
          myorigin = "$myhostname";
          mydestination = [
            "localhost"
          ];
          mynetworks = [
            "127.0.0.0/8"
            "[::1]/128"
          ];
          inet_interfaces = "loopback-only";
          smtpd_banner = "$myhostname ESMTP";
          smtp_tls_security_level = "may";
          smtp_tls_loglevel = "1";
          smtp_helo_name = "$myhostname";

          # Restricted entirely to system and service accounts
          authorized_submit_users = "nextcloud, root";

          smtpd_milters = "unix:/run/rspamd/worker-proxy.sock";
          non_smtpd_milters = "unix:/run/rspamd/worker-proxy.sock";
          milter_protocol = "6";
          milter_default_action = "accept";
        };
      };

      systemd.services."notify-backup-failure@" = {
        description = "Notify backup failure for %i";
        serviceConfig.Type = "oneshot";
        script = ''
          UNIT_NAME="%i"
          HOSTNAME=$(${pkgs.coreutils}/bin/cat /etc/hostname)
          TIMESTAMP=$(${pkgs.coreutils}/bin/date "+%Y-%m-%d %H:%M:%S %Z")
          
          # Get logs
          LOGS=$(${pkgs.systemd}/bin/journalctl -u "$UNIT_NAME" -n 50 --no-pager)

          (
            ${pkgs.coreutils}/bin/echo "To: leander@schererleander.de"
            ${pkgs.coreutils}/bin/echo "From: root@sachiel.schererleander.de"
            ${pkgs.coreutils}/bin/echo "Subject: Backup Failure: $UNIT_NAME"
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
            h1 { border-bottom: 2px solid #000; color: #c00; }
            pre, .crit { background: #f0f0f0; padding: 10px; font-family: monospace; font-size: 13px; }
            .crit { border-left: 4px solid #c00; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 15px; font-size: 13px; }
            th, td { text-align: left; padding: 6px; border-bottom: 1px solid #ddd; }
            @media (prefers-color-scheme: dark) {
              body { background: #121212; color: #eee; }
              h1, th { border-color: #555; }
              h1 { color: #ff6666; }
              pre, .crit { background: #1e1e1e; border-color: #eee; }
              .crit { border-left-color: #ff6666; }
              th, td { border-color: #333; }
            }
          </style>
          </head>
          <body>
            <h1>Backup Failure Alert</h1>
            
            <table>
              <tr><th>Unit</th><td>$UNIT_NAME</td></tr>
              <tr><th>Host</th><td>$HOSTNAME</td></tr>
              <tr><th>Time</th><td>$TIMESTAMP</td></tr>
            </table>

            <p><strong>Last 50 log lines:</strong></p>
            <div class="crit">
              <pre>$LOGS</pre>
            </div>
          </body>
          </html>
EOF
          ) | /run/wrappers/bin/sendmail -f root@sachiel.schererleander.de leander@schererleander.de
        '';
      };

      services.rspamd = {
        enable = true;
        locals."dkim_signing.conf".text = ''
          selector = "mail";
          path = "/var/lib/rspamd/dkim/mail.key";
          allow_username_mismatch = true;
          use_domain = "header";
          sign_authenticated = true;
          sign_local = true;
          use_esld = false;
        '';
      };
    };
}
