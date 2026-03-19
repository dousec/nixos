{ ... }:
{
  services = {
    n8n = {
      # enable = true;
      enable = false;
      openFirewall = true;
      environment = {
        N8N_PORT = 8081;
      };
    };
  };
}
