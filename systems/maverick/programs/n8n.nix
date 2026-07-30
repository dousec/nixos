{ ... }:
{
  services = {
    n8n = {
      enable = false;
      openFirewall = true;
      environment = {
        N8N_PORT = 8081;
      };
    };
  };
}
