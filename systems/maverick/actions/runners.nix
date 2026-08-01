{ pkgs, config, ... }:
{
  services = {
    github-runners = {
      "maverick-builder" = {
        enable = true;
        url = "https://github.com/dousec";
        tokenFile = config.sops.secrets."github/dousec/builder".path;
        extraPackages = with pkgs; [
          nix
        ];
      };

      "maverick-dousec" = {
        enable = true;
        url = "https://github.com/dousec";
        tokenFile = config.sops.secrets."github/dousec/runner".path;
        extraPackages = with pkgs; [
          nix
          attic-client
          podman
          git
          rsync
          bun
        ];
      };
    };

    gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances = {
        "maverick-dou" = {
          enable = true;
          name = "maverick-dou";
          url = "https://git.dousec.org";
          tokenFile = config.sops.templates."gitea-maverick-env".path;
          labels = [
            "native:host"
          ];
          hostPackages = with pkgs; [
            nix
            attic-client
            podman
            git
            rsync
          ];
        };
      };
    };
  };

  systemd.services = {
    "github-runner-maverick-dousec".serviceConfig.ReadWritePaths = [
      "/opt/gh/"
    ];
  };
  nix.settings.trusted-users = [ "github-runner-maverick-builder" ];
}
