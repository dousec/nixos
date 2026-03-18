{ pkgs, config, ... }:
{
  nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    hostName = "cloud.dousec.org";
    configureRedis = true;
    config = {
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
      dbpassFile = config.sops.secrets."nextcloud/dbpass".path;
      dbtype = "pgsql";
    };
    ensureUsers = {
      paulov = {
        email = "paulov@dousec.org";
        passwordFile = config.sops.secrets."users/paulov/pass".path;
      };
    };
  };

  nginx.virtualHosts."localhost".listen = [
    {
      addr = "127.0.0.1";
      port = 3001;
    }
  ];
}
