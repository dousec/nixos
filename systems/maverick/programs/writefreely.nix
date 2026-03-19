{ config, ... }:
{
  services = {
    writefreely = {
      enable = true;
      host = "blog.dousec.org";
      admin = {
        name = "root";
        initialPasswordFile = config.sops.secrets."user-password".path;
      };
      settings = {
        server = {
          port = 8083;
        };
      };
    };
  };
}
