{ pkgs, config, ... }:
{
  services = {
    github-runners = {
      "maverick-builder" = {
        enable = true;
        url = "https://github.com/dousec";
        tokenFile = config.sops.secrets."github/dousec/builder".path;
        extraPackages = [
          pkgs.nix
        ];
      };

      "maverick-dousec" = {
        enable = true;
        url = "https://github.com/dousec";
        tokenFile = config.sops.secrets."github/dousec/runner".path;
        extraPackages = [
          pkgs.nix
          pkgs.attic-client
          pkgs.podman
          pkgs.git
        ];
      };
    };
  };

  nix.settings.trusted-users = [ "github-runner-maverick-builder" ];
}
