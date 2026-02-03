{ inputs, ... }:
{
  flake.modules.nixos.secrets = { config, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    sops.defaultSopsFile = ../../../secrets/secrets.yaml;
    sops.age.keyFile = "/etc/sops/age_key";
  sops.secrets."borgbase_ssh_key" = {
    owner = "root";
    mode = "0600";
  };
  sops.secrets."nextcloud-admin-pass" = {
    owner = "root";
    mode = "0600";
  };
  sops.secrets."ssh_github_key" = {
    owner = "schererleander";
    mode = "0600";
  };
  sops.secrets."ssh_jonsbo_key" = {
    owner = "schererleander";
    mode = "0600";
  };
  sops.secrets."ssh_sachiel_key" = {
    owner = "schererleander";
    mode = "0600";
  };
  sops.secrets."ssh_borgbase_unraid_key" = {
    owner = "root";
    mode = "0600";
  };
  sops.secrets."ssh_config" = {
    owner = "schererleander";
    mode = "0600";
  };
  sops.secrets."borg_repo" = {
    owner = "root";
    mode = "0600";
  };
  };

  flake.modules.darwin.secrets = { config, ... }: {
    imports = [ inputs.sops-nix.darwinModules.sops ];
    sops.defaultSopsFile = ../../../secrets/secrets.yaml;
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  flake.modules.homeManager.secrets = { config, ... }: {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];
    sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    programs.ssh = {
      enable = true;
      includes = [ config.sops.secrets."ssh_config".path ];
    };
  };
}