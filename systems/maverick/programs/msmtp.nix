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
          host = "mx.paulov.dev";
          from = "noreply@paulov.dev";
          user = "noreply@paulov.dev";
          passwordeval = "cat ${config.sops.secrets."msmtp/users/default/pass".path}";
        };
      };
    };
  };
}
