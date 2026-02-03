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
      "borg_repo" = {
        owner = "root";
        mode = "0600";
      };
    };
  };
}
