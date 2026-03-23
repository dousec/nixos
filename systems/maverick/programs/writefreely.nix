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
	  landing = "/read";
	  wf_modesty = true;
	  reader = true;
	};
        server = {
          port = 8083;
        };
      };
    };
  };
}
