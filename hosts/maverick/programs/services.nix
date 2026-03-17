{ ... }:
{
  services = {
    # cloudflared = {
    #   enable = true;
    # };
    #
    # caddy = {
    #   enable = true;
    #   extraConfig = "
    #             ";
    # };

    adguardhome = {
      enable = true;
      port = 3000;
    };
  };
}
