{ lib, ... }:

let
  users = lib.pipe ./. [
    lib.readDir
    (lib.filterAttrs (_: type: type == "directory"))
    lib.attrNames
    (lib.filter (n: n != "default.nix"))
  ];
in
{
  home-manager.users = lib.genAttrs users (u: import ./${u}/home.nix);
  users.users = lib.genAttrs users (_: {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  });

  nix.settings.trusted-users = [ "root" ] ++ users;
}
