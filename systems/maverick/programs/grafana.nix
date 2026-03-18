{ config, ... }:
{
  services = {
    grafana = {
      enable = true;
      openFirewall = true;
      settings = {
        server = {
          http_port = 8084;
          enforce_domain = true;
          enable_gzip = true;
          domain = "dashboard.me";
        };
        analytics = {
          reporting_enabled = false;
        };
      };
      provision = {
        enable = true;
        datasources = {
          settings = {
            datasources = [
              {
                name = "ECX12FMS";
                type = "prometheus";
                url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
                isDefault = true;
                editable = false;
              }
            ];
          };
        };
      };
    };

    prometheus = {
      enable = true;
      globalConfig = {
        scrape_interval = "5m";
      };
      scrapeConfigs = [
        {
          job_name = "ECX12FMS Node";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
      ];
      exporters = {
        node = {
          enable = true;
          port = 9000;
          enabledCollectors = [
            "ethtool"
            "softirqs"
            "systemd"
            "tcpstat"
            "wifi"
          ];
          extraFlags = [ "--collector.ntp.protocol-version=4" ];
        };
      };
    };
  };
}
