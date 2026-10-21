{ config, ... }:
{
  services = {
    forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.paulov.dev";
          ROOT_URL = "https://git.paulov.dev/";
          HTTP_PORT = 8086;
          DISABLE_SSH = true;
          LANDING_PAGE = "explore";
        };

        service = {
          REGISTER_EMAIL_CONFIRM = true;
          EMAIL_DOMAIN_ALLOWLIST = "paulov.dev";
        };

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };

        mailer = {
          ENABLED = true;
          SMTP_ADDR = "mx.paulov.dev";
          FROM = "noreply@paulov.dev";
          USER = "noreply@paulov.dev";
        };
      };

      secrets = {
        mailer.PASSWD = config.sops.secrets."msmtp/users/default/pass".path;
      };
    };
  };
}
