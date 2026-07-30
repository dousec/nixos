{ ... }:
{
  services = {
    memos = {
      enable = false;
      settings = {
        MEMOS_PORT = 8082;
        MEMOS_DATA = "/var/lib/memos";
      };
    };
  };
}
