{ config, ... }:
let
  n8nUser = "n8n";
in
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
          image = "docker.io/n8n/n8n";
          ports = [ "127.0.0.1:8081:5678" ];
          environment = {
            N8N_PORT = "5678";
            N8N_PROTOCOL = "http";
            N8N_HOST = "n8n.dousec.org";
            DB_TYPE = "postgresdb";
            DB_POSTGRESDB_HOST = "host.containers.internal";
            DB_POSTGRESDB_PORT = "5432";
            DB_POSTGRESDB_DATABASE = "n8n";
            DB_POSTGRESDB_USER = "n8n";
          };
          environmentFiles = [
            config.sops.templates."n8n-env".path
          ];
          volumes = [
            "/opt/n8n:/home/node/.n8n"
          ];
          podman = {
            user = n8nUser;
            sdnotify = "conmon";
          };
          autoStart = true;
        };
      };
    };
  };

  users.users.${n8nUser} = {
    isSystemUser = true;
    group = n8nUser;
    linger = true;
  };
  users.groups.${n8nUser} = { };

  systemd.tmpfiles.rules = [
    "d /opt/n8n 0750 ${n8nUser} ${n8nUser} - -"
  ];

}
