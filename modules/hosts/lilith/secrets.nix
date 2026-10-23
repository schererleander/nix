{
  flake.modules.darwin.lilith =
    { inputs, lib, ... }:
    {
      imports = [ inputs.self.modules.darwin.sops ];
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
            mode = "0600";
          })
        // {
          "nebula/ca.crt" = {
            owner = "root";
            mode = "0400";
          };
          "nebula/host.crt" = {
            key = "nebula/lilith/crt";
            owner = "root";
            mode = "0400";
          };
          "nebula/host.key" = {
            key = "nebula/lilith/key";
            owner = "root";
            mode = "0400";
          };
        };
    };
}
