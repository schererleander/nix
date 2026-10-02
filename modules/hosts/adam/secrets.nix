{
  flake.modules.nixos.adam =
    { inputs, lib, ... }:
    {
      imports = [ inputs.self.modules.nixos.sops ];
      sops.secrets =
        lib.genAttrs
          [
            "ssh_github_key"
            "ssh_jonsbo_key"
            "ssh_sachiel_key"
            "anki_username"
            "anki_syncKey"
          ]
          (_: {
            owner = "schererleander";
            group = "users";
            mode = "0600";
          })
        // {
          ssh_authorized_keys = {
            owner = "schererleander";
            group = "users";
            mode = "0644";
            path = "/etc/ssh/authorized_keys.d/schererleander";
          };
        };
    };
}
