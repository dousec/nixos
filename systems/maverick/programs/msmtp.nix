{ config, ... }:
{
  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        tls = true;
        auth = true;
        host = "dousec.org";
        from = "noreply@dousec.org";
        user = "noreply@dousec.org";
        passwordeval = "cat ${config.sops.secret."msmtp/users/default/pass".path}";
      };
    };
  };
}
