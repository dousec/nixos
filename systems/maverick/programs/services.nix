{ pkgs, config, ... }:
{
  services = {
    openssh = {
      enable = true;
      settings = {
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-256"
        ];
      };
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
    };
  };

  systemd = {
    services = {
      chisel = {
        description = "chisel client to forward ports";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        # wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Restart = "always";
          RestartSec = "5s";
          User = "root";
        };

        script = ''
          ${pkgs.chisel}/bin/chisel client \
            --auth "ecx12fms:$(cat ${config.sops.secrets."chisel/pass".path})" \
            129.153.185.116:8028 \
            R:0.0.0.0:5222:127.0.0.1:5222 \
            R:0.0.0.0:5269:127.0.0.1:5269 \
            R:0.0.0.0:5280:127.0.0.1:5280 \
            R:0.0.0.0:5281:127.0.0.1:5281
        '';
      };
    };
  };
}
