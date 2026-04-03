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
        app = {
          site_name = "Dou";
          wf_modesty = true;
        };
        server = {
          port = 8083;
        };
      };
    };
  };
}
