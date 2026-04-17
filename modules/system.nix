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
        # nixpkgs.config.allowUnfree = true; # propietary CUDA drivers for NVIDIA GPUs
        # nixpkgs.config.nvidia.acceptLicense = true;
        imports = [
          "${self}/users/default.nix"
          path
        ]
        ++ [
          inputs.sops-nix.nixosModules.sops
          inputs.nix-topology.nixosModules.default
        ];
      };
in
{
  flake.nixosConfigurations = {
    maverick = mkLinuxStandard "${self}/systems/maverick/configuration.nix";
  };
}
