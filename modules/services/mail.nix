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

      systemd.services."weekly-report" = {
        description = "Generate and send weekly server report";
        serviceConfig.Type = "oneshot";
        script = ''
          HOSTNAME=$(${pkgs.coreutils}/bin/cat /etc/hostname)
          
          # 1. System Health
          UPTIME=$(${pkgs.procps}/bin/uptime -p)
          FAILED_SERVICES=$(${pkgs.systemd}/bin/systemctl --failed --no-legend --no-pager | ${pkgs.coreutils}/bin/head -n 5)
          [ -z "$FAILED_SERVICES" ] && FAILED_SERVICES="None"
          DISK_USAGE=$(${pkgs.coreutils}/bin/df -h)

          # 2. Security Overview
          BANNED_ROWS=$(${pkgs.systemd}/bin/journalctl _COMM=fail2ban --since "1 week ago" --no-pager | ${pkgs.gnugrep}/bin/grep " Ban " | ${pkgs.gawk}/bin/awk '{
            # Log format: May 30 12:00:00 host fail2ban[123]: [jail] Ban IP
            date = $1 " " $2
            match($0, /\[(.*)\] Ban (.*)/, m)
            jail = m[1]
            ip = m[2]
            print "<tr><td><a href=\"https://iplookup.flagfox.net/?ip=" ip "\">" ip "</a></td><td>" jail "</td><td>" date "</td></tr>"
          }')
          [ -z "$BANNED_ROWS" ] && BANNED_ROWS="<tr><td colspan=\"3\">No new bans this week.</td></tr>"

          LOGIN_ROWS=$(${pkgs.systemd}/bin/journalctl _SYSTEMD_UNIT=sshd.service --since "1 week ago" --no-pager | ${pkgs.gnugrep}/bin/grep -E "Accepted (publickey|password)" | ${pkgs.gawk}/bin/awk '{
            # Log format: May 30 12:00:00 host sshd-session[123]: Accepted publickey for user from IP ...
            date = $1 " " $2 " " substr($3, 1, 5)
            user = $9
            ip = $11
            print "<tr><td>" user "</td><td><a href=\"https://iplookup.flagfox.net/?ip=" ip "\">" ip "</a></td><td>" date "</td></tr>"
          }')
          [ -z "$LOGIN_ROWS" ] && LOGIN_ROWS="<tr><td colspan=\"3\">No logins recorded.</td></tr>"

          # 3. Backup Status
          parse_backups() {
            ${pkgs.systemd}/bin/journalctl -u "$1" --since "1 week ago" --no-pager | ${pkgs.gawk}/bin/awk '
              /Archive name:/ { d=$1" "$2; n=$NF }
              /Size \(compressed\):/ { s=$(NF-2)" "$(NF-1) }
              /Duration:/ { t=$NF; if (n != "") { 
                if (n ~ /\.failed$/) {
                  printf "<tr><td><span class=\"failed\">%s</span></td><td>%s</td><td><span class=\"failed\">FAILED</span></td><td>%s</td></tr>\n", n, d, t
                } else {
                  printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", n, d, s, t
                }
                n="" 
              } }
            ' | ${pkgs.coreutils}/bin/tail -n 5
          }

          GIT_BACKUP_ROWS=$(parse_backups "borgbackup-job-git")
          [ -z "$GIT_BACKUP_ROWS" ] && GIT_BACKUP_ROWS="<tr><td colspan=\"4\">No recent logs.</td></tr>"

          NC_BACKUP_ROWS=$(parse_backups "borgbackup-job-nextcloud")
          [ -z "$NC_BACKUP_ROWS" ] && NC_BACKUP_ROWS="<tr><td colspan=\"4\">No recent logs.</td></tr>"

          # 4. Critical Events
          ERRORS=$(${pkgs.systemd}/bin/journalctl -p 0..3 --since "1 week ago" --no-pager | ${pkgs.coreutils}/bin/head -n 20)
          [ -z "$ERRORS" ] && ERRORS="No critical errors recorded."

          # Construct HTML
          (
            ${pkgs.coreutils}/bin/echo "To: leander@schererleander.de"
            ${pkgs.coreutils}/bin/echo "From: root@sachiel.schererleander.de"
            ${pkgs.coreutils}/bin/echo "Subject: Weekly Report: $HOSTNAME"
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
            h1 { border-bottom: 2px solid #000; }
            h2 { border-bottom: 1px solid #ccc; text-transform: uppercase; font-size: 16px; margin-top: 30px; }
            pre, .crit { background: #f0f0f0; padding: 10px; font-family: monospace; font-size: 13px; }
            .crit { border-left: 4px solid #000; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 15px; font-size: 13px; }
            th, td { text-align: left; padding: 6px; border-bottom: 1px solid #ddd; }
            th { border-bottom: 2px solid #000; }
            a { color: #0066cc; }
            .failed { color: #c00; }
            @media (prefers-color-scheme: dark) {
              body { background: #121212; color: #eee; }
              h1, h2, th { border-color: #555; }
              pre, .crit { background: #1e1e1e; border-color: #eee; }
              th, td { border-color: #333; }
              a { color: #66b3ff; }
              .failed { color: #ff6666; }
            }
          </style>
          </head>
          <body>
            <h1>Weekly Report: $HOSTNAME</h1>
            
            <h2>Server Health</h2>
            <p><strong>Uptime:</strong> $UPTIME</p>
            <p><strong>Failed Services:</strong> $FAILED_SERVICES</p>
            <p><strong>Disk Usage:</strong></p>
            <pre>$DISK_USAGE</pre>

            <h2>Security Overview</h2>
            <p><strong>Newly Banned IPs:</strong></p>
            <table>
              <tr><th>IP Address</th><th>Jail</th><th>Date</th></tr>
              $BANNED_ROWS
            </table>

            <p><strong>Successful SSH Logins:</strong></p>
            <table>
              <tr><th>User</th><th>IP Address</th><th>Date</th></tr>
              $LOGIN_ROWS
            </table>

            <h2>Backup Status</h2>
            <p><strong>Git Repository</strong></p>
            <table>
              <tr><th>Archive</th><th>Date</th><th>Size</th><th>Duration</th></tr>
              $GIT_BACKUP_ROWS
            </table>

            <p><strong>Nextcloud Repository</strong></p>
            <table>
              <tr><th>Archive</th><th>Date</th><th>Size</th><th>Duration</th></tr>
              $NC_BACKUP_ROWS
            </table>

            <h2>Critical Events</h2>
            <div class="crit"><pre style="margin: 0; white-space: pre-wrap; font-family: inherit;">$ERRORS</pre></div>
          </body>
          </html>
EOF
          ) | /run/wrappers/bin/sendmail -f root@sachiel.schererleander.de leander@schererleander.de
        '';
      };

      systemd.timers."weekly-report" = {
        description = "Timer for weekly server report";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "Mon 08:00:00";
          Persistent = true;
        };
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
