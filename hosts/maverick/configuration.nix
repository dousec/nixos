{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./programs/services.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "maverick";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Guayaquil";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    53
    300
    80
  ];
  networking.firewall.allowedUDPPorts = [
    53
    3000
    80
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11"; # Yes, I read the comment

}
