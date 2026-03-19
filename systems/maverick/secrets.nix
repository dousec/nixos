{ ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/maverick/prod.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "user-password" = {
        owner = "writefreely"; # writefreely requests it
      };

      "users/root/pass" = { };
      "users/paulov/pass" = { };

      "msmtp/users/default/pass" = { };

      "grafana/secret_key" = { };

      "api/gemini/token" = { };
      "api/groq/token" = { };

      "cloudflared/tunnel/argo_key" = { };
      "cloudflared/dns/token" = { };

      "chisel/pass" = { };

      "attic/server-token" = { };

      "github/dousec/runner" = { };
    };
  };
}
