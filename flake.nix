{
  description = "Fully-compatible NixOS config with flake-parts, colmena and home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # colmena.url = "github:zhaofengli/colmena";
    nixos-unified.url = "github:srid/nixos-unified";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = (
        with builtins;
        concatLists [
          (map (mod: ./modules/${mod}) (attrNames (readDir ./modules)))
          [
            inputs.treefmt-nix.flakeModule
            inputs.nixos-unified.flakeModules.default
          ]
        ]
      );

      systems = [ "x86_64-linux" ]; # add more system if you have to

      perSystem =
        {
          config,
          ...
        }:
        {
          formatter = config.treefmt.build.wrapper;

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              deadnix.enable = true; # dead-code
            };
          };
        };
    };
}
