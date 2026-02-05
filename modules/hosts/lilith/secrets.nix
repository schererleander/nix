{
  flake.modules.darwin.lilith =
    { inputs, ... }:
    {
      imports = [ inputs.sops-nix.darwinModules.sops ];
      sops = {
        defaultSopsFile = inputs.self + /secrets/secrets.yaml;
        age.keyFile = "/etc/sops/age_key";
        secrets = {
          "ssh_github_key" = {
            owner = "schererleander";
            mode = "0600";
          };
          "ssh_jonsbo_key" = {
            owner = "schererleander";
            mode = "0600";
          };
          "ssh_sachiel_key" = {
            owner = "schererleander";
            mode = "0600";
          };
        };
      };
    };
}
