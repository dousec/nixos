{ config, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers = {
      backend = "podman";
      containers = {
        n8n = {
          image = "docker.io/n8nio/n8n";
          environment = {
            N8N_PORT = "8082";
            N8N_PROTOCOL = "http";
            N8N_HOST = "n8n.dousec.org";
            DB_TYPE = "postgresdb";
            DB_POSTGRESDB_HOST = "localhost";
            DB_POSTGRESDB_PORT = "5432";
            DB_POSTGRESDB_DATABASE = "n8n";
            DB_POSTGRESDB_USER = "n8n";
          };
          extraOptions = [
            "--user=0:0"
            "--network=host"
          ];
          environmentFiles = [
            config.sops.templates."n8n-env".path
          ];
          volumes = [
            "/opt/n8n:/home/node/.n8n"
          ];
          autoStart = true;
        };
      };
    };
  };
}
