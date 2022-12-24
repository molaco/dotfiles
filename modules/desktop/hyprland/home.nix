{ config, lib, pkgs, ... }:

{
#  imports = [ ../../environment/hypr-variables.nix ];
  
  home = {
    packages = with pkgs; [
      swaybg
      swaylock-effects
    ];
  };

  home.file = {
    ".config/hypr/hyprland.conf".text = ''

	monitor=,preferred,auto,1.25
	
	
	
	# Execute your favorite apps at launch
	exec-once = waybar
	exec-once = swaybg -i "${./wallpaper/default.png}"
	
	# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
	input {
	    kb_layout = es
	    kb_variant =
	    kb_model =
	    kb_options =
	    kb_rules =
	
	    follow_mouse = 1
	
	    touchpad {
	        natural_scroll = yes
	    }
	
	    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
	}
	
	# General
	general {
	    gaps_in = 6
	    gaps_out = 12
	    border_size = 2
	    #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
	    #col.inactive_border = rgba(595959aa)
	    col.active_border=0xffcba6f7
    	    col.inactive_border=0xff313244
	    layout = dwindle
	}
	
	decoration {	
	    
	    # Rounding
	    rounding = 8

	    #Blur
	    blur = yes
	    blur_size = 10
	    blur_passes = 4
	    blur_new_optimizations = on
	
	    # Shadow
	    #drop_shadow = yes
	    #shadow_range = 4
	    #shadow_render_power = 3
	    #col.shadow = rgba(1a1a1aee)
	    drop_shadow = true
    	    shadow_ignore_window = true
    	    shadow_offset = 2 2
    	    shadow_range = 4
	    shadow_render_power = 2
    	    col.shadow = 0x66000000

	    # Blurring layerSurfaces
            blurls = gtk-layer-shell
            blurls = waybar
            blurls = lockscreen

	}

	# Blurs
	blurls = gtk-layer-shell
  	blurls = waybar
  	blurls = lockscreen
	
	# Animations
	animations {
	    enabled = yes
	
	    # Bexier Curve
	    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
	    bezier = overshot, 0.05, 0.9, 0.1, 1.05
    	    bezier = smoothOut, 0.36, 0, 0.66, -0.56
    	    bezier = smoothIn, 0.25, 1, 0.5, 1

	
	    # Animation list
	    animation = windows, 1, 7, myBezier
	    animation = windowsOut, 1, 7, default, popin 80%
	    animation = border, 1, 10, default
	    animation = fade, 1, 7, default
	    animation = workspaces, 1, 6, default

	    #animation = windows, 1, 5, overshot, slide
    	    #animation = windowsOut, 1, 4, smoothOut, slide
    	    #animation = windowsMove, 1, 4, default
    	    #animation = border, 1, 10, default
    	    #animation = fade, 1, 10, smoothIn
    	    #animation = fadeDim, 1, 10, smoothIn
    	    #animation = workspaces, 1, 6, overshot, slidevert
	}

	# Gestures
  	gestures {
	    workspace_swipe = true
	    workspace_swipe_fingers = 3
	  }
	
	dwindle {
	    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
	    preserve_split = yes # you probably want this
	}
	
	master {
	    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
	    new_is_master = true
	}
	
		
	# Window Rules
	windowrule = float, file_progress
  	windowrule = float, confirm
  	windowrule = float, dialog
  	windowrule = float, download
  	windowrule = float, notification
  	windowrule = float, error
  	windowrule = float, splash
  	windowrule = float, confirmreset
  	windowrule = float, title:Open File
  	windowrule = float, title:branchdialog
  	windowrule = float, zoom
  	windowrule = float, vlc
  	windowrule = float, Lxappearance
  	windowrule = float, ncmpcpp
  	windowrule = float, Rofi
  	windowrule = animation none, Rofi
  	windowrule = float, viewnior
  	windowrule = float, pavucontrol-qt
  	windowrule = float, gucharmap
  	windowrule = float, gnome-font
  	windowrule = float, org.gnome.Settings
  	windowrule = float, file-roller
  	windowrule = float, nautilus
  	windowrule = float, nemo
  	windowrule = float, thunar
  	windowrule = float, Pcmanfm
  	windowrule = float, obs
  	windowrule = float, wdisplays
  	windowrule = float, zathura
  	windowrule = float, *.exe
  	windowrule = fullscreen, wlogout
  	windowrule = float, title:wlogout
  	windowrule = fullscreen, title:wlogout
  	windowrule = float, pavucontrol-qt
  	windowrule = float, keepassxc
  	windowrule = idleinhibit focus, mpv
  	windowrule = idleinhibit fullscreen, firefox
  	windowrule = float, title:^(Media viewer)$
  	windowrule = float, title:^(Transmission)$
  	windowrule = float, title:^(Volume Control)$
  	windowrule = float, title:^(Picture-in-Picture)$
  	windowrule = float, title:^(Firefox — Sharing Indicator)$
  	windowrule = move 0 0, title:^(Firefox — Sharing Indicator)$
  	windowrule = size 800 600, title:^(Volume Control)$
  	windowrule = move 75 44%, title:^(Volume Control)$
	
	# KeyBinds
	$mainMod = SUPER
	
	# Apps
	bind = $mainMod, Return, exec, kitty
	bind = $mainMod, B, exec, firefox
	bind = $mainMod, F, exec, thunar
	bind = $mainMod, R, exec, wofi --show drun

	# System
	bind = $mainMod, Q, killactive, 
	bind = $mainMod, M, exit, 
	bind = $mainMod, V, togglefloating, 
	bind = $mainMod, P, pseudo, # dwindle
	bind = $mainMod, J, togglesplit, # dwindle

	 # Screenshots
  	 $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
  	 bind = , Print, exec, $screenshotarea
  	 bind = CTRL, Print, exec, grimblast --notify --cursor copysave output
  	 bind = SUPER SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output
  	 bind = ALT, Print, exec, grimblast --notify --cursor copysave screen
  	 bind = SUPER SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen
     bind = SUPER, G, exec, grim -g "$(slurp)" copysave screen

	# Misc
  	bind = CTRL ALT, L, exec, swaylock
  	bind = SUPER SHIFT, O, exec, run-as-service wl-ocr
	
	# Move focus with mainMod + arrow keys
	bind = $mainMod, left, movefocus, l
	bind = $mainMod, right, movefocus, r
	bind = $mainMod, up, movefocus, u
	bind = $mainMod, down, movefocus, d

	# Move Window
  	bind = SUPER CTRL SHIFT, left, movewindow, l
  	bind = SUPER CTRL SHIFT, right, movewindow, r
  	bind = SUPER CTRL SHIFT, up, movewindow, u
  	bind = SUPER CTRL SHIFT, down, movewindow, d

	# Resize
  	bind = SUPER ALT, left, resizeactive, -20 0
  	bind = SUPER ALT, right, resizeactive, 20 0
  	bind = SUPER ALT, up, resizeactive, 0 -20
  	bind = SUPER ALT, down, resizeactive, 0 20


	# Switch workspaces with mainMod + SHIFT + arrow keys
	bind = $mainMod SHIFT, left, workspace, -1
	bind = $mainMod SHIFT, right, workspace, +1
	
	# Switch workspaces with mainMod + [0-9]
	bind = $mainMod, 1, workspace, 1
	bind = $mainMod, 2, workspace, 2
	bind = $mainMod, 3, workspace, 3
	bind = $mainMod, 4, workspace, 4
	bind = $mainMod, 5, workspace, 5
	bind = $mainMod, 6, workspace, 6
	bind = $mainMod, 7, workspace, 7
	bind = $mainMod, 8, workspace, 8
	bind = $mainMod, 9, workspace, 9
	bind = $mainMod, 0, workspace, 10
	
	# Move active window to a workspace with mainMod + SHIFT + [0-9]
	bind = $mainMod SHIFT, 1, movetoworkspace, 1
	bind = $mainMod SHIFT, 2, movetoworkspace, 2
	bind = $mainMod SHIFT, 3, movetoworkspace, 3
	bind = $mainMod SHIFT, 4, movetoworkspace, 4
	bind = $mainMod SHIFT, 5, movetoworkspace, 5
	bind = $mainMod SHIFT, 6, movetoworkspace, 6
	bind = $mainMod SHIFT, 7, movetoworkspace, 7
	bind = $mainMod SHIFT, 8, movetoworkspace, 8
	bind = $mainMod SHIFT, 9, movetoworkspace, 9
	bind = $mainMod SHIFT, 0, movetoworkspace, 10

	# Move active window to a workspace with mainMod + CTRL + arrow keys 
	bind = $mainMod CTRL, left, movetoworkspace, -1 
	bind = $mainMod CTRL, right, movetoworkspace, +1 
	
	# Scroll through existing workspaces with mainMod + scroll
	bind = $mainMod, mouse_down, workspace, e+1
	bind = $mainMod, mouse_up, workspace, e-1
	
	# Move/resize windows with mainMod + LMB/RMB and dragging
	bindm = $mainMod, mouse:272, movewindow
	bindm = $mainMod, mouse:273, resizewindow
    '';
  };
}
