{ config, lib, pkgs, ... }:
{

  services.dbus.enable = true;

  environment = {

    variables = { 
      WLR_NO_HARDWARE_CURSORS="1";
      XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_TYPE="wayland";
      XDG_SESSION_DESKTOP="Hyprland";
      MOZ_ENABLE_WAYLAND = "1";
    };

    systemPackages = with pkgs; [
      grim
      mpvpaper
      slurp
      swappy
      wl-clipboard
      wlr-randr
    ];
  };

  programs = {
    hyprland.enable = true;
  };
}
