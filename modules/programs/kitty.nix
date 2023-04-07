{ config, pkgs, ... }:

{
  programs = {
    kitty = {
      enable = true;
      environment = { };
      settings = {
        url_color = "#0087bd";
	      window_padding_width = "0";
      	mouse_hide_wait = "0";
      	focus_follows_mouse = "no";
        url_style = "dotted";
        confirm_os_window_close = 0;
        background_opacity = "1";
        linux_display_server = "x11";
      };
      theme = "Catppuccin-Mocha";
      font.name = "FiraMono Medium";
      #font.size = 15;
      font.size = 12;
    };
  };
}
