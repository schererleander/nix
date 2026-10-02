{ inputs, ... }:
let
  sops = {
    defaultSopsFile = inputs.self + /secrets/secrets.yaml;
    age.keyFile = "/etc/sops/age_key";
  };
in
{
  flake.modules.nixos.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    inherit sops;
  };

  flake.modules.darwin.sops = {
    imports = [ inputs.sops-nix.darwinModules.sops ];
    inherit sops;
  };
}
