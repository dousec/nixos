{ pkgs, ... }:

{
  imports = (
    with builtins;
    concatLists [
      (map (ctx: ./programs/${ctx}) (attrNames (readDir ./programs)))
      [
        ./hardware-configuration.nix
      ]
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
    53
    3000
    80
  ];
  networking.firewall.allowedUDPPorts = [
    53
  ];
  system.stateVersion = "25.11"; # Yes, I read the comment
}
