{ ... }:
{
  sops = {
    defaultSopsFile = "${self}/secrets/maverick/prod.yaml";
    pgp.sshKeyPaths = [ "/etc/ssh/ssh_host_rsa_key" ];
    secrets = {
      test = { };
    };
  };
}
