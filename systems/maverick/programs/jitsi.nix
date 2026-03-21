{ ... }:
{
  services = {
    jitsi-meet = {
      enable = true;
      hostName = "meets.dousec.org";
      prosody.lockdown = true;
      config = {
        enableWelcomePage = false;
        prejoinPageEnabled = true;
        defaultLang = "en";
      };
      caddy.enable = true;
      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
      };
    };
    jitsi-videobridge.openFirewall = true;
  };
}
