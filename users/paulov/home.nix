{ pkgs, ... }:
{
  home.username = "paulov";
  programs.zsh.enable = true;
  # programs.git.enable = true; it must be enabled by default on any machine, i expect that..
  home.packages = with pkgs; [
    nh
  ];
  home.stateVersion = "25.05";
}
