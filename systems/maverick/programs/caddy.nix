{ ... }:
{
  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        "".extraConfig = ""; # pending config
      };
    };
  };
}
