{ ... }:
{
  services = {
    memos = {
      enable = true;
      openFirewall = true;
      settings = {
        MEMOS_PORT = 8082;
      };
    };
  };
}
