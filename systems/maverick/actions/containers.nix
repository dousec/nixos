{ config, ... }:
let
  formsPort = 8090;
  formsHost = "forms.paulov.dev";
  formsVersion = "2.8.6";

  formsNginxConf = ''
    map $request_uri $api_uri {
      ~^/api(/.*$) $1;
      default $request_uri;
    }

    server {
      listen 80;
      server_name _;
      root /usr/share/nginx/html/public;
      client_max_body_size 64m;

      access_log /dev/stdout;
      error_log /dev/stderr error;

      index index.html index.htm index.php;

      location / {
        proxy_http_version 1.1;
        proxy_pass http://forms-client:3000;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
      }

      location ^~ /api/_nuxt_icon/ {
        proxy_http_version 1.1;
        proxy_pass http://forms-client:3000;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
      }

      location ~/(api|open|local\/temp|forms\/assets)/ {
        try_files $uri $uri/ /index.php$is_args$args;
      }

      location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass forms-api:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root/index.php;
        fastcgi_param REQUEST_URI $api_uri;
        fastcgi_param HTTP_X_FORWARDED_FOR $proxy_add_x_forwarded_for;
        fastcgi_param HTTP_X_FORWARDED_HOST $http_x_forwarded_host;
        fastcgi_param HTTP_X_FORWARDED_PORT $http_x_forwarded_port;
        fastcgi_param HTTP_X_FORWARDED_PROTO $http_x_forwarded_proto;
      }

      location ~ ^/\.well-known/(oauth-authorization-server|oauth-protected-resource(/mcp)?)$ {
        rewrite ^ /index.php last;
      }

      location ~ /\. {
        deny all;
      }
    }
  '';

  formsApiCommon = {
    image = "docker.io/jhumanj/opnform-api:${formsVersion}";
    environmentFiles = [ config.sops.templates."forms-env".path ];
    environment = {
      APP_ENV = "production";
      APP_DEBUG = "false";
      DB_CONNECTION = "pgsql";
      DB_HOST = "forms-db";
      DB_PORT = "5432";
      DB_DATABASE = "opnform";
      DB_USERNAME = "opnform";
      REDIS_HOST = "forms-redis";
      REDIS_PORT = "6379";
      CACHE_STORE = "redis";
      QUEUE_CONNECTION = "redis";
      SESSION_DRIVER = "redis";
      FILESYSTEM_DRIVER = "local";
      APP_URL = "https://${formsHost}";
      FRONT_URL = "https://${formsHost}";
      JWT_SKIP_IP_UA_VALIDATION = "false";
      WEBHOOKS_ALLOW_PRIVATE_URLS = "true";
      PHP_MEMORY_LIMIT = "1G";
      PHP_MAX_EXECUTION_TIME = "600";
      PHP_UPLOAD_MAX_FILESIZE = "64M";
      PHP_POST_MAX_SIZE = "64M";
    };
    volumes = [ "/opt/forms/storage:/usr/share/nginx/html/storage:Z,U" ];
    autoStart = true;
  };
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
          image = "docker.io/n8nio/n8n";
          pull = "newer";
          environment = {
            N8N_PORT = "8082";
            N8N_PROTOCOL = "http";
            N8N_HOST = "flows.paulov.dev";
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

        bifrost = {
          image = "docker.io/maximhq/bifrost";
          pull = "newer";
          ports = [ "8083:8080" ];
          volumes = [
            "/opt/bifrost:/app/data:Z"
          ];
          autoStart = true;
        };

        forms-db = {
          image = "docker.io/library/postgres:16-alpine";
          environment = {
            POSTGRES_DB = "opnform";
            POSTGRES_USER = "opnform";
          };
          environmentFiles = [ config.sops.templates."forms-db-env".path ];
          volumes = [ "/opt/forms/db-data:/var/lib/postgresql/data:Z,U" ];
          autoStart = true;
        };

        forms-redis = {
          image = "docker.io/library/redis:7-alpine";
          cmd = [
            "redis-server"
            "--appendonly"
            "yes"
          ];
          volumes = [ "/opt/forms/redis-data:/data:Z,U" ];
          autoStart = true;
        };

        forms-api = formsApiCommon // {
          dependsOn = [
            "forms-db"
            "forms-redis"
          ];
        };

        forms-api-worker = formsApiCommon // {
          cmd = [
            "php"
            "artisan"
            "queue:work"
          ];
          dependsOn = [
            "forms-db"
            "forms-redis"
            "forms-api"
          ];
        };

        forms-api-country-worker = formsApiCommon // {
          cmd = [
            "php"
            "artisan"
            "queue:work"
            "--queue=form-view-country"
            "--timeout=30"
          ];
          dependsOn = [
            "forms-db"
            "forms-redis"
            "forms-api"
          ];
        };

        forms-api-scheduler = formsApiCommon // {
          cmd = [
            "php"
            "artisan"
            "schedule:work"
          ];
          dependsOn = [
            "forms-db"
            "forms-redis"
            "forms-api"
          ];
        };

        forms-client = {
          image = "docker.io/jhumanj/opnform-client:${formsVersion}";
          environmentFiles = [ config.sops.templates."forms-client-env".path ];
          environment = {
            NUXT_PUBLIC_APP_URL = "https://${formsHost}";
            NUXT_PUBLIC_API_BASE = "https://${formsHost}/api";
            NUXT_PRIVATE_API_BASE = "http://forms-ingress/api";
          };
          dependsOn = [ "forms-api" ];
          autoStart = true;
        };

        forms-ingress = {
          image = "docker.io/library/nginx:1-alpine";
          volumes = [
            "${builtins.toFile "forms-nginx.conf" formsNginxConf}:/etc/nginx/conf.d/default.conf:ro"
          ];
          ports = [ "${toString formsPort}:80" ];
          dependsOn = [
            "forms-client"
            "forms-api"
          ];
          autoStart = true;
        };
      };
    };
  };
}
