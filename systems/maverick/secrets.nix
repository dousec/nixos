{ ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/maverick/prod.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      # "user-password" = {
      #   owner = "writefreely"; # writefreely requests it
      # };

      "users/root/pass" = { };

      "msmtp/users/default/pass" = {
        owner = "nextcloud";
      };

      "grafana/secret_key" = { };

      "litellm/master_key" = { };

      "api/gemini/token" = { };
      "api/groq/token" = { };

      "cloudflared/tunnel/argo_key" = { };
      "cloudflared/dns/token" = {
        owner = "acme";
      };

      "chisel/pass" = { };

      "attic/server-token" = { };

      "github/dousec/runner" = { };
      "github/dousec/builder" = { };
    };
  };
}
