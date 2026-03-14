{
  flake.modules.nixos.secrets =
    { inputs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        defaultSopsFile = inputs.self + /secrets/secrets.yaml;
        age.keyFile = "/etc/sops/age_key";
        secrets = {
          "borgbase_ssh_key" = {
            owner = "root";
            mode = "0600";
          };
          "nextcloud-secrets" = {
            owner = "nextcloud";
            group = "nextcloud";
            mode = "0400";
          };
          "nextcloud-admin-pass" = {
            owner = "root";
            mode = "0600";
          };
          "ssh_github_key" = {
            owner = "administrator";
            mode = "0600";
          };
          "ssh_jonsbo_key" = {
            owner = "administrator";
            mode = "0600";
          };
          "ssh_sachiel_key" = {
            owner = "administrator";
            mode = "0600";
          };
          "borg_git_repo" = {
            owner = "root";
            mode = "0600";
          };
          "borg_nextcloud_repo" = {
            owner = "root";
            mode = "0600";
          };
          "ssh_git_pubkey" = {
            owner = "git";
            group = "git";
            mode = "0400";
            path = "/var/lib/git-server/.ssh/authorized_keys";
          };
          "cert_fullchain" = {
            owner = "nginx";
            group = "nginx";
          };
          "cert_private" = {
            owner = "nginx";
            group = "nginx";
          };
        };
      };
    };
}
