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
  };

  nix.settings.trusted-users = [ "github-runner-maverick-builder" ];
}
