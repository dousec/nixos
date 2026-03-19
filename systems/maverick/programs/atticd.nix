{ config, ... }:
{
  services = {
    atticd = {
      enable = true;
      environmentFile = config.sops.secrets."attic/server-token".path;
      settings = {
        listen = "[::]:8081";
        api-endpoint = "https://attic.dousec.org/";
      };
    };
  };
}
