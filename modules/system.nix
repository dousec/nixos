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
          "${self}/users/default.nix"
          path
        ]
        ++ [
          inputs.sops-nix.nixosModules.sops
        ];
      };
in
{
  flake.nixosConfigurations = {
    maverick = mkLinuxStandard "${self}/systems/maverick/configuration.nix";
  };
}
