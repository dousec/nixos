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
          ExecStart = ''
            ${pkgs.chisel}/bin/chisel client \
              --auth "ecx12fms:$(cat ${config.sops.secrets."chisel/pass".path})" \
              129.153.185.116:8028 \
              5222:5222 \
              5269:5269 \
              5280:5280 \
              5281:5281
          '';
          Restart = "always";
          RestartSec = "5s";
          User = "root";
        };
      };
    };
  };
}
