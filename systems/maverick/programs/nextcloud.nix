{ pkgs, config, ... }:
{
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
        sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
      }
    }/nextcloud-extras.nix"
  ];

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      hostName = "cloud.dousec.org";
      webserver = "caddy";
      configureRedis = true;
      config = {
        adminpassFile = config.sops.secrets."users/root/pass".path;
        dbtype = "pgsql";
      };
      database = {
        createLocally = true;
      };
      ensureUsers = {
        paulov = {
          email = "paulov@dousec.org";
          passwordFile = config.sops.secrets."users/paulov/pass".path;
        };
      };
      settings = {
        mail_smtpmode = "sendmail";
        mail_sendmailmode = "pipe";
      };
    };

    redis.servers.nextcloud = {
      enable = true;
      port = 0;
    };
  };
}
