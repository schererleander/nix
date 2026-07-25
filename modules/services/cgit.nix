{
  flake.modules.nixos.cgit =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.cgit."git-server" = {
        enable = true;

        scanPath = "/var/lib/git-server";

        user = "git";
        group = "git";

        nginx.virtualHost = "git.schererleander.de";

        gitHttpBackend = {
          enable = true;
          checkExportOkFiles = false;
        };

        settings = {
          "root-title" = "My Git Repositories";
          "root-desc" = "Self-hosted NixOS Git server";
          "clone-url" =
            "https://git.schererleander.de/$CGIT_REPO_URL ssh://git@git.schererleander.de/$CGIT_REPO_URL";
          "enable-http-clone" = 1;
          "enable-commit-graph" = 1;
          "enable-log-filecount" = 1;
          "enable-log-linecount" = 1;
          "branch-sort" = "age";

          readme = ":README.md";

          "about-filter" = "${pkgs.writeShellScript "cgit-about-filter" ''
            case "$1" in
              *.md) 
                ${pkgs.lowdown}/bin/lowdown -Thtml --html-no-skiphtml --html-no-escapehtml 
                ;;
              *) 
                ${pkgs.coreutils}/bin/cat 
                ;;
            esac
          ''}";
        };
      };

      services.nginx.virtualHosts."git.schererleander.de" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets."cert_fullchain".path;
        sslCertificateKey = config.sops.secrets."cert_private".path;
      };
    };
}
