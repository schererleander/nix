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
