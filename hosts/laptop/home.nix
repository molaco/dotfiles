{ config, lib, pkgs, user, ... }:

{
  imports =
    # [ (import ../../modules/desktop/gnome/home.nix) ] ++
    [ (import ../../modules/desktop/hyprland/home.nix) ] ++
    (import ../../modules/shell) ++
#    (import ../../modules/editors) ++
    (import ../../modules/programs) ++
    (import ../../modules/themes) ;

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };

}
