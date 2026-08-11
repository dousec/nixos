{ config, ... }:
{
  services = {
    cloudflared = {
      enable = true;
      tunnels = {
        "0a2cf345-ad5c-4c81-82f1-ae6c0b63185d" = {
          credentialsFile = config.sops.secrets."cloudflared/dousec/tunnel/argo_key".path;
          ingress = {
            "git.dousec.org" = "http://localhost:8086";
            "cloud.dousec.org" = "http://localhost:8087";
            "attic.dousec.org" = "http://localhost:8081";
            "dousec.org" = "http://localhost:80";
            "papers.dousec.org" = "http://localhost:80";
            "n8n.dousec.org" = "http://localhost:80";
          };
          default = "http_status:404";
        };

        "10c3b49e-4690-4b4a-b83d-a7f81b8c8549" = {
          credentialsFile = config.sops.secrets."cloudflared/paulov/tunnel/argo_key".path;
          ingress = {
            "paulov.dev" = "http://localhost:80";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
