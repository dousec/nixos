{ inputs, ... }:
let
  inherit (inputs) self;
in
{
  flake.nixosConfigurations = {
    maverick =
      self.nixos-unified.lib.mkLinuxSystem
        {
          home-manager = true;
        }
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          imports = [
            ./../hosts/maverick/configuration.nix
            ./../users/default.nix
          ];
        };
  };
}
