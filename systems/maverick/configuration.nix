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

  hardware.graphics.enable = true;
  hardware.nvidia.open = false;
  services.xserver.videoDrivers = [ "nvidia" ];

  networking.hostName = "maverick";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Guayaquil";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    neovim
    sops
    # cloudflared use it log in
    chisel
    attic-client
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

  topology = {
    self = {
      hardware.info = "i5 6400 16GB DDR4 GTX 1060 3GB SSD 1TB";
    };
  };

  system.stateVersion = "25.11"; # Yes, I read the comment
}
