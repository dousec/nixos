{ config, ... }:
{
  services = {
    cloudflared = {
      enable = true;
      tunnels = {
        "10c3b49e-4690-4b4a-b83d-a7f81b8c8549" = {
          credentialsFile = config.sops.secrets."cloudflared/paulov/tunnel/argo_key".path;
          ingress = {
            "flows.paulov.dev" = "http://localhost:8082";
            "forms.paulov.dev" = "http://localhost:8090";
            "gateway.paulov.dev" = "http://localhost:8083";
            "git.paulov.dev" = "http://localhost:8086";
            "hub.paulov.dev" = "http://localhost:8087";
            "paulov.dev" = "http://localhost:80";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
