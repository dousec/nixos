{ config, ... }:
{
  services = {
    writefreely = {
      enable = true;
      host = "blog.dousec.org";
      admin = {
        name = "root";
        initialPasswordFile = config.sops.secrets."users/root/pass".path;
      };
      settings = {
        server = {
          port = 8083;
        };
      };
    };
  };
}
