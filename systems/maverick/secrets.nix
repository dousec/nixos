{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/maverick/prod.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "api/gemini/token" = { };
      "api/groq/token" = { };
      "attic/server-token" = { };
      "chisel/pass" = { };
      "cloudflared/dns/token" = {
        owner = "acme";
      };
      "cloudflared/tunnel/argo_key" = { };
      "gitea/dou/runner" = { };
      "github/dousec/builder" = { };
      "github/dousec/runner" = { };
      "grafana/secret_key" = { };
      "litellm/master_key" = { };
      "msmtp/users/default/pass" = {
        owner = "nextcloud";
      };
      "n8n/db_password" = { };
      "users/root/pass" = { };
    };

    templates = {
      "n8n-env" = {
        content = ''
          DB_POSTGRESDB_PASSWORD=${config.sops.placeholder."n8n/db_password"}
        '';
      };
      "gitea-maverick-env" = {
        content = ''
          TOKEN=${config.sops.placeholder."gitea/dou/runner"}
        '';
      };
    };
  };
}
