{ config, ... }:
let
  inherit (config.services) grafana;
  get = opt: toString opt;
in
{
  services = {
    cloudflared = {
      enable = true;
      tunnels = {
        "0a2cf345-ad5c-4c81-82f1-ae6c0b63185d" = {
          credentialsFile = config.sops.secrets."cloudflared/tunnel/argo_key".path;
          ingress = {
            "foo.dousec.org" = "http://localhost:${get grafana.settings.server.http_port}";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
