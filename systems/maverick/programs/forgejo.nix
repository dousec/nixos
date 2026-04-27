{ config, ... }:
{
  services = {
    forgejo = {
      enable = false;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.dousec.org";
          ROOT_URL = "https://git.dousec.org/";
          HTTP_PORT = 8086;
        };
        
	service.DISABLE_REGISTRATION = true;
        
	actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
        mailer = {
          ENABLED = true;
          SMTP_ADDR = "mail.dousec.org";
          FROM = "noreply@dousec.org";
          USER = "noreply@dousec.org";
        };
      };
      secrets = {
        mailer.PASSWD = config.sops.secrets."msmtp/users/default/pass".path;
      };
    };
  };
}
