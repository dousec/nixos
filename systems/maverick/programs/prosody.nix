{ config, ... }:
let
  sslCertDir = config.security.acme.certs."dousec.org".directory;
in
{
  services = {
    prosody = {
      enable = true;
      admins = [ "paulov@dousec.org" ];
      allowRegistration = false;
      ssl = {
        cert = "${sslCertDir}/fullchain.pem";
        key = "${sslCertDir}/key.pem";
      };
      virtualHosts = {
        "dousec.org" = {
          domain = "dousec.org";
          enabled = true;
        };
      };
      muc = [
        {
          domain = "conference.dousec.org";
          restrictRoomCreation = true;
        }
      ];
      httpFileShare = {
        domain = "upload.dousec.org";
      };
      extraConfig = ''
                storage = "sql"
                sql = {
                  driver = "SQLite3";
                  database = "prosody.sqlite";
                }

        	external_addresses = { "129.153.185.116" } -- i have to forward ports to my vps for tcp/udp connection :p
      '';
    };
  };
}
