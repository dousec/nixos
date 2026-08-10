{ config, ... }:
let
  inherit (config.services) adguardhome;
  get = opt: toString opt;
in
{
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "root@dousec.org";
      certs = {
        "dousec.org" = {
          group = "prosody";
          extraDomainNames = [
            "*.dousec.org"
          ];
          dnsProvider = "cloudflare";
          credentialFiles = {
            "SECRET_FILE" = config.sops.secrets."cloudflared/dousec/dns/token".path;
          };
        };
      };
    };
  };

  services = {
    caddy = {
      enable = true;
      globalConfig = ''
        tls internal
      '';
      virtualHosts = {
        "dns.me:80".extraConfig = ''
          reverse_proxy http://localhost:${get adguardhome.port}
        '';

        "n8n.dousec.org:80".extraConfig = ''
          reverse_proxy http://localhost:8082
        '';

        "dousec.org:80".extraConfig = ''
          root * /opt/gh/www/dousec.org
          file_server
        '';

        "papers.dousec.org:80".extraConfig = ''
          root * /opt/gh/www/papers.dousec.org
          file_server
        '';

        "home.paulov.dev:80".extraConfig = ''
          	  respond "hllo world"
        '';

      };
    };
  };
}
