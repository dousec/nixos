{ pkgs, ... }:

{
  imports = (
    with builtins;
    concatLists [
      [
        ./hardware-configuration.nix
        ./secrets.nix
      ]
      (map (ctx: ./actions/${ctx}) (attrNames (readDir ./actions)))
      (map (ctx: ./programs/${ctx}) (attrNames (readDir ./programs)))
    ]
  );

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  # boot.loader.grub.device = "/dev/vda";

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  networking.hostName = "maverick";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Guayaquil";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    neovim
    sops
    cloudflared
    chisel
  ];

  programs.git.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.firewall.allowedTCPPorts = [
    53 # dns resolver
    80 # http traffic, most commonly addressed by cloudflare tunnel
  ];

  networking.firewall.allowedUDPPorts = [
    53 # udp dns resolver
  ];

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  system.stateVersion = "25.11"; # Yes, I read the comment
}
