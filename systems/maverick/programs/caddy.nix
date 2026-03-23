{ config, ... }:
let
  inherit (config.services) adguardhome grafana litellm;
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
          credentialsFile = config.sops.secrets."cloudflared/dns/token".path;
        };
      };
    };
  };

  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        "dns.me:80".extraConfig = ''
          	  tls internal
          	  reverse_proxy http://localhost:${get adguardhome.port}
          	'';

        "dashboard.me:80".extraConfig = ''
          	  tls internal
                  reverse_proxy http://localhost:${get grafana.settings.server.http_port}
        '';

        # "n8n.me:80".extraConfig = ''
        #          	  tls internal
        #          	  reverse_proxy http://localhost:${get n8n.environment.N8N_PORT}
        #          	'';

        "litellm.me:80".extraConfig = ''
          	  tls internal
          	  reverse_proxy http://localhost:${get litellm.port}
          	'';

        "dousec.org:80".extraConfig = ''
          	          tls internal
                    	  root * /var/lib/www/dousec.org
                    	  file_server
                    	'';

        "paulov.dousec.org:80".extraConfig = ''
          		  tls internal
          		  handle /twtxt.txt {
          		  	root * /var/lib/www/paulov.dousec.org
          			file_server
          		  }
          		  respond "proxy unauthorized"
          		'';

        "jesus.dousec.org:80".extraConfig = ''
                    		  tls internal
          			  root * /var/lib/www/jesus.dousec.org
          			  file_server
                    		'';

      };
    };
  };
}
