{ config, ... }:
{
  services = {
    writefreely = {
      enable = false;
      host = "blog.dousec.org";
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
