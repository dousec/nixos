{ config, ... }:
{
  programs = {
    msmtp = {
      enable = true;
      defaults = {
        tls = true;
        port = 587;
      };
      accounts = {
        default = {
          auth = true;
          host = "mail.dousec.org";
          from = "noreply@dousec.org";
          user = "noreply@dousec.org";
          passwordeval = "cat ${config.sops.secrets."msmtp/users/default/pass".path}";
        };
      };
    };
  };
}
