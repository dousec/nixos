{ ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/maverick/prod.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "users/paulov/pass" = { };

      "nextcloud/adminpass" = { };
      "nextcloud/dbpass" = { };
    };
  };
}
