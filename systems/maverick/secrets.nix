{ ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/maverick/prod.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "users/root/pass" = { };
      "users/paulov/pass" = { };

      "msmtp/users/default/pass" = { };

      "grafana/secret_key" = { };

      "api/gemini/token" = { };
      "api/groq/token" = { };
    };
  };
}
