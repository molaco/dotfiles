{ config, pkgs, ... }:

{
  programs = {
    kitty = {
      enable = true;
      environment = { };
      settings = {
        url_color = "#0087bd";
	window_padding_width = "15";
	mouse_hide_wait = "0";
      	focus_follows_mouse = "no";
        url_style = "dotted";
        confirm_os_window_close = 0;
        background_opacity = "0.1";
      };
      theme = "Catppuccin-Mocha";
      font.name = "FiraMono Medium";
      font.size = 12;
    };
  };
}
