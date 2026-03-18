{ ... }:
{
  sopas = {
    defaultSopsFile = "/etc/nixos/secrets/maverick/prod.yaml";
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      test = {};
    };
  };
}
