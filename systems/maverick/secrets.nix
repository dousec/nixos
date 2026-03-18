{ ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/maverick/prod.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "users/paulov/pass" = { };

      "msmtp/users/default/pass" = { };

      "nextcloud/admin/pass" = { };
    };
  };
}
