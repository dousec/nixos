{ ... }:
{
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "root@dousec.org";
      certs = {
        "dousec.org" = {
          webroot = "/var/lib/acme/acme-challenge";
          group = "nginx";
        };
      };
    };
  };

  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        "".extraConfig = ""; # pending config
      };
    };
  };
}
