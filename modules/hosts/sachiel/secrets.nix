{
  flake.modules.nixos.sachiel =
    { inputs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        defaultSopsFile = inputs.self + /secrets/secrets.yaml;
        age.keyFile = "/etc/sops/age_key";
        secrets = {
          "nextcloud-secrets" = {
            owner = "nextcloud";
            group = "nextcloud";
            mode = "0400";
          };
          "nextcloud-admin-pass" = {
            owner = "root";
            mode = "0600";
          };
          # SSL certificates
          "cert_fullchain" = {
            owner = "nginx";
            group = "nginx";
          };
          "cert_private" = {
            owner = "nginx";
            group = "nginx";
          };
          # Backup configuration
          "borgbase_ssh_key" = {
            owner = "root";
            mode = "0600";
          };
          "borg_repo" = {
            owner = "root";
            mode = "0600";
          };
        };
      };
    };
}
