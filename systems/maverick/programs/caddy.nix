{ config, ... }:
let
  inherit (config.services) adguardhome;
  get = opt: toString opt;
in
{
  # security = {
  #   acme = {
  #     acceptTerms = true;
  #     defaults.email = "root@dousec.org";
  #     certs = {
  #       "dousec.org" = {
  #         group = "prosody";
  #         extraDomainNames = [
  #           "*.dousec.org"
  #         ];
  #         dnsProvider = "cloudflare";
  #         credentialFiles = {
  #           "SECRET_FILE" = config.sops.secrets."cloudflared/dousec/dns/token".path;
  #         };
  #       };
  #     };
  #   };
  # };

  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        "dns.me:80".extraConfig = ''
          	  tls internal
                    reverse_proxy http://localhost:${get adguardhome.port}
        '';

        "paulov.dev:80".extraConfig = ''
          	  tls internal
              redir https://github.com/hyduez 301
        '';

      };
    };
  };
}
