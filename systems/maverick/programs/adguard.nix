{ ... }:
{
  services = {
    adguardhome = {
      enable = true;
      port = 8080;
      openFirewall = true;
      settings = {
        dns = {
          upstream_dns = [
            "https://1.1.1.1/dns-query"
            "https://9.9.9.10/dns-query"
          ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;

          parental_enabled = false;
          safe_search = {
            enabled = false;
          };
        };
        filters =
          map
            (url: {
              enabled = true;
              url = url;
            })
            [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
              "https://raw.githubusercontent.com/ph00lt0/blocklist/master/blocklist.txt"
            ];
      };
    };
  };
}
