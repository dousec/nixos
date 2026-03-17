{ inputs, ... }:
let
  inherit (inputs) self;
  mkLinuxStandard =
    path:
    self.nixos-unified.lib.mkLinuxSystem
      {
        home-manager = true;
      }
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        imports = [
          ./../users/default.nix
          ./../hosts/common.nix
          path
        ];
      };
in
{
  flake.nixosConfigurations = {
    maverick = mkLinuxStandard ../hosts/maverick/configuration.nix;
  };
}
