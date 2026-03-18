{ pkgs, config, ... }:
{
  services = {

    openssh = {
      enable = true;
    };

    # cloudflared = {
    #   enable = true;
    # };
    #
    # caddy = {
    #   enable = true;
    #   extraConfig = "
    #             ";
    # };

    adguardhome = {
      enable = true;
      port = 3000;
    };

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "cloud.dousec.org";
      configureRedis = true;
      config = {
        adminpassfile = config.sops.secrets.nextcloud.adminpass;
        dbpassFile = config.sops.secrets.nextcloud.dbpass;
        dbtype = "postgresql";
      };
    };
  };
}
