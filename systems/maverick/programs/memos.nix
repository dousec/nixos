{ ... }:
{
  services = {
    memos = {
      enable = true;
      settings = {
        MEMOS_PORT = 8082;
	MEMOS_DATA = "/var/lib/memos";
      };
    };
  };
}
