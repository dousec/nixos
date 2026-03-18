{ ... }:
{
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "root@dousec.org";
      certs = {
        "dousec.org" = {
          group = "nginx";
          allowKeysForGroup = true;
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
