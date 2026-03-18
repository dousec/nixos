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

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    hostName = "192.168.122.28";
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
    webserver = "caddy";
  };
}
