{ config, ... }:
let
  inherit (config.services) grafana memos writefreely;
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

            "blog.dousec.org" = "http://localhost:${get writefreely.settings.server.port}";
            "notes.dousec.org" = "http://localhost:${get memos.settings.MEMOS_PORT}";

            "attic.dousec.org" = "http://localhost:8081";

            # xmpp and mail are handled by chisel server side

            # caddy handled
            "cloud.dousec.org" = "http://localhost:80";
            "dousec.org" = "http://localhost:80";
            "paulov.dousec.org" = "http://localhost:80";
            "jesus.dousec.org" = "http://localhost:80";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
