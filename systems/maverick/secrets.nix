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
      "cloudflared/paulov/tunnel/argo_key" = { };
      "github/dousec/builder" = { };
      "github/dousec/runner" = { };
      "grafana/secret_key" = { };
      "litellm/master_key" = { };
      "msmtp/users/default/pass" = {
        owner = "nextcloud";
      };
      "n8n/db_password" = { };
      "forms/app_key" = { };
      "forms/jwt_secret" = { };
      "forms/front_api_secret" = { };
      "forms/db_password" = { };
      "users/root/pass" = { };
    };

    templates = {
      "n8n-env" = {
        content = ''
          DB_POSTGRESDB_PASSWORD=${config.sops.placeholder."n8n/db_password"}
          N8N_ENCRYPTION_KEY=${config.sops.placeholder."n8n/db_password"}
        '';
      };

      "forms-env" = {
        content = ''
          APP_KEY=${config.sops.placeholder."forms/app_key"}
          JWT_SECRET=${config.sops.placeholder."forms/jwt_secret"}
          FRONT_API_SECRET=${config.sops.placeholder."forms/front_api_secret"}
          DB_PASSWORD=${config.sops.placeholder."forms/db_password"}
        '';
      };

      "forms-db-env" = {
        content = ''
          POSTGRES_PASSWORD=${config.sops.placeholder."forms/db_password"}
        '';
      };

      "forms-client-env" = {
        content = ''
          NUXT_API_SECRET=${config.sops.placeholder."forms/front_api_secret"}
        '';
      };
    };
  };
}
