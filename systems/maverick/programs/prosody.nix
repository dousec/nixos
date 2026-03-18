{ config, ... }:
let
  sslCertDir = config.security.acme.certs."dousec.org".directory;
in
{
  services = {
    prosody = {
      enable = false;
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
      extraConfig = ''
        storage = "sql"
        sql = {
          driver = "SQLite3";
          database = "prosody.sqlite"; -- The database name to use. For SQLite3 this the database filename (relative to the data storage directory).
        }
      '';
    };
  };
}
