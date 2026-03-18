{ pkgs, ... }:

{
  imports = (
    with builtins;
    concatLists [
      [
        ./hardware-configuration.nix
        ./secrets.nix
      ]
      (map (ctx: ./programs/${ctx}) (attrNames (readDir ./programs)))
    ]
  );

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "maverick";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Guayaquil";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    sops
  ];

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
  system.stateVersion = "25.11"; # Yes, I read the comment
}
