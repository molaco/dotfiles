{
  config,
  pkgs,
  ...
}: let

  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    #!/usr/bin/env bash
    rofi_command="rofi -theme $HOME/.config/rofi/powermenu.rasi"
    
    uptime=$(uptime -p | sed -e 's/up //g')
    
    # Options
    if [[ "$DIR" == "powermenus" ]]; then
    	shutdown=""
    	reboot=""
    	lock=""
    	suspend=""
    	logout=""
    	ddir="$HOME/.config/rofi"
    else
    
    # For some reason the Icons are mess up I don't know why but to fix it uncomment section 2 and comment section 1 but if the section 1 icons are mess up uncomment section 2 and comment section 1
    
    	# Buttons
    	layout=`cat $HOME/.config/rofi/powermenu.rasi | grep BUTTON | cut -d'=' -f2 | tr -d '[:blank:],*/'`
    	if [[ "$layout" == "TRUE" ]]; then
    
    		shutdown=""
    		reboot=""
    		lock=""
    		suspend=""
    		logout=""
    
    	else
      # Section 1
    		shutdown=" Shutdown"
    		reboot=" Restart"
    		lock=" Lock"
    		suspend=" Sleep"
    		logout=" Logout"
    	fi
    	ddir="$HOME/.config/rofi"
    fi
    
    # Ask for confirmation
    rdialog () {
    rofi -dmenu\
        -i\
        -no-fixed-num-lines\
        -p "Are You Sure? : "\
        -theme "$ddir/confirm.rasi"
    }
    
    # Display Help
    show_msg() {
    	rofi -theme "$ddir/askpass.rasi" -e "Options : yes / no / y / n"
    }
    
    # Variable passed to rofi
    options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"
    
    chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 0)"
    case $chosen in
        $shutdown)
    		ans=$(rdialog &)
    		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
    			systemctl poweroff
    		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
    			exit
            else
    			show_msg
            fi
            ;;
        $reboot)
    		ans=$(rdialog &)
    		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
    			systemctl reboot
    		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
    			exit
            else
    			show_msg
            fi
            ;;
        $lock)
            sh $HOME/.local/bin/lock
            ;;
        $suspend)
    		ans=$(rdialog &)
    		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
    			mpc -q pause
    			amixer set Master mute
    			sh $HOME/.local/bin/lock
    			systemctl suspend
    		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
    			exit
            else
    			show_msg
            fi
            ;;
        $logout)
    		ans=$(rdialog &)
    		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
    			bspc quit
    		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
    			exit
            else
    			show_msg
            fi
            ;;
    esac
  '';

  launcher = pkgs.writeShellScriptBin "launcher" ''
    rofi \
	    -show drun \
	    -modi run,drun,ssh \
	    -scroll-method 0 \
	    -drun-match-fields all \
	    -drun-display-format "{name}" \
	    -no-drun-show-actions \
	    -terminal kitty \
      -kb-cancel Super_L \
	    -theme "$HOME"/.config/rofi/launcher.rasi
  '';

in {
  home.packages = with pkgs; [
    (rofi-wayland.override {
      plugins = [rofi-emoji];
    })
    power-menu
    launcher
    wl-clipboard
    wtype
  ];

  xdg.configFile."rofi/powermenu.rasi".text = ''
    configuration {
        show-icons:                     true;
        display-drun: 		            "";
        drun-display-format:            "{icon} {name}";
        disable-history:                false;
        click-to-exit: 		            true;
        location:                       4;
    }
    
    @import "font.rasi"
    @import "colors.rasi"
    
    /* Line Responsible For Button Layouts */
    /* BUTTON = TRUE */
    
    window {
        transparency:                   "real";
        background-color:               @BG;
        text-color:                     @FG;
        border:                  	    2px;
        border-color:                   @BGA;
        border-radius:                  10px;
        width:                          110px;
        x-offset:                       -1%;
        y-offset:                       0;
    }
    
    prompt {
        enabled: 			            true;
        margin: 			            0px 0px 0px 8px;
        padding: 			            8px;
        background-color: 		        @BG;
        text-color: 		            @FG;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
    }
    
    textbox-prompt-colon {
        expand: 			            false;
        str: 			                "";
        border-radius:                  100%;
        background-color:               @BG;
        text-color:                     @BG;
        padding:                        8px 12px 8px 12px;
        font:			                "Iosevka Nerd Font 10";
    }
    
    entry {
        background-color:               @BG;
        text-color:                     @FG;
        placeholder-color:              @FG;
        expand:                         true;
        horizontal-align:               0;
        placeholder:                    "Search...";
        blink:                          true;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
        padding:                        8px;
    }
    
    inputbar {
        children: 		                [ textbox-prompt-colon ];
        background-color:               @BG;
        text-color:                     @FG;
        expand:                         false;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  0px;
        border-color:                   @BDR;
        margin:                         0px 0px 0px 0px;
        padding:                        0px;
        position:                       center;
    }
    
    case-indicator {
        background-color:               @BG;
        text-color:                     @FG;
        spacing:                        0;
    }
    
    
    listview {
        background-color:               @BG;
        columns:                        1;
        lines:			                5;
        spacing:                        15px;
        cycle:                          true;
        dynamic:                        true;
        layout:                         vertical;
    }
    
    mainbox {
        background-color:               @BG;
        children:                       [ listview ];
        spacing:                        15px;
        padding:                        15px;
    }
    
    element {
        background-color:               @BG;
        text-color:                     @FG;
        orientation:                    horizontal;
        border-radius:                  10px;
        padding:                        20px;
    }
    
    element-icon {
        background-color: 		        inherit;
        text-color:       		        inherit;
        horizontal-align:               0.5;
        vertical-align:                 0.5;
        size:                           0px;
        border:                         0px;
    }
    
    element-text {
        background-color: 		        inherit;
        text-color:       		        inherit;
        font:			                "feather 20";
        expand:                         true;
        horizontal-align:               0.5;
        vertical-align:                 0.5;
        margin:                         0px 0px 0px 0px;
    }
    
    element selected {
        background-color:               @BGA;
        text-color:                     @SEL;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  10px;
        border-color:                   @BDR;
    }
    
    element.active,
    element.selected.urgent {
      background-color: @ON;
      text-color: @BG;
      border-color: @ON;
    }
    
    element.selected.urgent {
      border-color: @BDR;
    }
    
    element.urgent,
    element.selected.active {
      background-color: @OFF;
      text-color: @BG;
      border-color: @OFF;
    }
    
    element.selected.active {
      border-color: @BDR;
    }
  '';

  xdg.configFile."rofi/askpass.rasi".text = ''
    @import "colors.rasi"
    @import "font.rasi"
    
    * {
        background-color:       @BG;
        text-color:             @FG;
    }
    
    window {
        width:        	        250px;
        padding:    	        20px;
        border:		            0px 0px 2px 0px;
        border-radius:          8px;
        border-color:           @BDR;
        location:               0;
        x-offset:               0;
        y-offset:               -4%;
    }
    
    entry {
        expand: 		        true;
        width: 		            150px;
        text-color:		        @BDR;
    }
  '';

  xdg.configFile."rofi/bluetooth.rasi".text = ''
    configuration {
        show-icons:                     false;
        display-drun: 		            "";
        drun-display-format:            "{icon} {name}";
        disable-history:                false;
        click-to-exit: 		            true;
        location:                       0;
    }
    
    @import "font.rasi"
    @import "colors.rasi"
    
    window {
        transparency:                   "real";
        background-color:               @BG;
        text-color:                     @FG;
        border:                         2px;
        border-color:                   @BDR;
        border-radius:                  10px;
        width:                          300px;
        anchor:                         center;
        x-offset:                       0;
        y-offset:                       0;
    }
    
    prompt {
        enabled: 			            true;
        margin: 			            0px 8px 0px 8px;
        padding: 			            8px;
        background-color: 	            @IMG;
        text-color: 	                @BG;
        border:                  	    0px 0px 0px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
    }
    
    textbox-prompt-colon {
        expand: 			            false;
        str: 			                "";
        border-radius:                  100%;
        background-color:               @SEL;
        text-color:                     @FG;
        padding:                        8px 12px 8px 12px;
        font:			                "Iosevka Nerd Font 10";
    }
    
    entry {
        background-color:               @BG;
        text-color:                     @FG;
        placeholder-color:              @FG;
        expand:                         true;
        horizontal-align:               0;
        placeholder:                    "";
        blink:                          true;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
        padding:                        8px;
    }
    
    inputbar {
        children: 		                [ textbox-prompt-colon, prompt, entry ];
        background-color:               @BG;
        text-color:                     @FG;
        expand:                         false;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  0px;
        border-color:                   @BDR;
        margin:                         0px 0px 0px 0px;
        padding:                        0px;
        position:                       center;
    }
    
    case-indicator {
        background-color:               @BG;
        text-color:                     @FG;
        spacing:                        0;
    }
    
    
    listview {
        background-color:               @BG;
        columns:                        1;
        lines:			    7;
        spacing:                        4px;
        cycle:                          true;
        dynamic:                        true;
        layout:                         vertical;
    }
    
    mainbox {
        background-color:               @BG;
        children:                       [ inputbar, listview ];
        spacing:                       	15px;
        padding:                        15px;
    }
    
    element {
        background-color:               @BG;
        text-color:                     @FG;
        orientation:                    horizontal;
        border-radius:                  4px;
        padding:                        6px 6px 6px 6px;
    }
    
    element-icon {
        background-color: 				inherit;
        text-color:       				inherit;
        size:                           0px;
        border:                         0px;
    }
    
    element-text {
        background-color: 				inherit;
        text-color:       				inherit;
        expand:                         true;
        horizontal-align:               0;
        vertical-align:                 0.5;
        margin:                         2px 0px 2px 6px;
    }
    
    element normal.urgent,
    element alternate.urgent {
        background-color:               @UGT;
        text-color:                     @FG;
        border-radius:                  9px;
    }
    
    element normal.active,
    element alternate.active {
        background-color:               @BGA;
        text-color:                     @FG;
    }
    
    element selected {
        background-color:               @BGA;
        text-color:                     @SEL;
        border:                  		0px 0px 0px 0px;
        border-radius:                  10px;
        border-color:                  	@BDR;
    }
    
    element selected.urgent {
        background-color:               @UGT;
        text-color:                     @FG;
    }
    
    element selected.active {
        background-color:               @BGA;
        color:                          @FG;
    }
  '';

  xdg.configFile."rofi/colors.rasi".text = ''
    * {
        BG:    #2E3440;
        BGA:   #81a1c1;
        FG:    #eceff4;
        FGA:   #81a1c1;
        BDR:   #81a1c1;
        SEL:   #1E1E2Eff;
        UGT:   #F28FADff;
        IMG:   #81a1c1;
        OFF:   #575268ff;
        ON:    #81a1c1;
    }
  '';

  xdg.configFile."rofi/confirm.rasi".text = ''
    @import "colors.rasi"
    @import "font.rasi"
    
    * {
        background-color:       @BG;
        text-color:             @FG;
    }
    
    window {
        width:      	        200px;
        padding:                20px;
        border:		            0px 0px 2px 0px;
        border-radius:          8px;
        border-color:           @BDR;
        location:               0;
        x-offset:               0;
        y-offset:               -4%;
    }
    
    entry {
        expand: 		        true;
        width: 		            150px;
        text-color:		        @BDR;
    }
  '';
  
  xdg.configFile."rofi/font.rasi".text = ''
    * {
        font:				 	"Iosevka 10";
    }
  '';

  xdg.configFile."rofi/launcher.rasi".text = ''
    configuration {
        show-icons:                     true;
        display-drun: 		            "";
        drun-display-format:            "{icon} {name}";
        disable-history:                false;
        click-to-exit: 		            true;
        location:                       0;
    }
    
    @import "font.rasi"
    @import "colors.rasi"
    
    window {
        transparency:                   "real";
        background-color:               @BG;
        text-color:                     @FG;
        border:                         2px;
        border-color:                   @BDR;
        border-radius:                  10px;
        width:                          500px;
        anchor:                         center;
        x-offset:                       0;
        y-offset:                       0;
    }
    
    prompt {
        enabled: 			            true;
        padding: 			            8px;
        background-color: 		        @BG;
        text-color: 		            @IMG;
    }
    
    textbox-prompt-colon {
        expand: 			            false;
        str: 			                "";
        border-radius:                  100%;
        background-color:               @SEL;
        text-color:                     @FG;
        padding:                        8px 12px 8px 12px;
        font:			                "Iosevka Nerd Font 10";
    }
    
    entry {
        background-color:               @BG;
        text-color:                     @FG;
        placeholder-color:              @FG;
        expand:                         true;
        horizontal-align:               0;
        placeholder:                    "Search...";
        blink:                          true;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
        padding:                        8px;
    }
    
    inputbar {
    	children: 		                [ textbox-prompt-colon, prompt, entry ];
        background-color:               @BG;
        text-color:                     @FG;
        expand:                         false;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  0px;
        border-color:                   @BDR;
        margin:                         0px 0px 0px 0px;
        padding:                        0px;
        position:                       center;
    }
    
    case-indicator {
        background-color:               @BG;
        text-color:                     @FG;
        spacing:                        0;
    }
    
    
    listview {
        background-color:               @BG;
        columns:                        1;
        lines:			                7;
        spacing:                        4px;
        cycle:                          false;
        dynamic:                        true;
        layout:                         vertical;
    }
    
    mainbox {
        background-color:               @BG;
        children:                       [ inputbar, listview ];
        spacing:                        15px;
        padding:                        15px;
    }
    
    element {
        background-color:               @BG;
        text-color:                     @FG;
        orientation:                    horizontal;
        border-radius:                  4px;
        padding:                        6px 6px 6px 6px;
    }
    
    element-icon {
        background-color: 	            inherit;
        text-color:       		        inherit;
        horizontal-align:               0.5;
        vertical-align:                 0.5;
        size:                           24px;
        border:                         0px;
    }
    
    element-text {
        background-color: 		        inherit;
        text-color:       		        inherit;
        expand:                         true;
        horizontal-align:               0;
        vertical-align:                 0.5;
        margin:                         2px 0px 2px 2px;
    }
    
    element normal.urgent,
    element alternate.urgent {
        background-color:               @UGT;
        text-color:                     @FG;
        border-radius:                  9px;
    }
    
    element normal.active,
    element alternate.active {
        background-color:               @BGA;
        text-color:                     @FG;
    }
    
    element selected {
        background-color:               @BGA;
        text-color:                     @SEL;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  10px;
        border-color:                   @BDR;
    }
    
    element selected.urgent {
        background-color:               @UGT;
        text-color:                     @FG;
    }
    
    element selected.active {
        background-color:               @BGA;
        color:                          @FG;
    }
  '';

  xdg.configFile."rofi/mpd.rasi".text = ''
    configuration {
        show-icons:                     false;
        display-drun: 		            "";
        drun-display-format:            "{icon} {name}";
        disable-history:                false;
        click-to-exit: 		            true;
        location:                       0;
    }
    
    @import "font.rasi"
    @import "colors.rasi"
    
    /* Line Responsible For Button Layouts */
    /* BUTTON = FALSE */
    
    window {
        transparency:                   "real";
        background-color:               @BG;
        text-color:                     @FG;
        border:                         2px;
        border-color:                   @BDR;
        border-radius:                  10px;
        width:                          400px;
        anchor:                         center;
        x-offset:                       0;
        y-offset:                       0;
    }
    
    prompt {
        enabled: 			            true;
        margin: 			            0px 0px 0px 8px;
        padding: 			            8px;
        background-color: 		        @BG;
        text-color: 		            @FG;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
    }
    
    textbox-prompt-colon {
        expand: 			            false;
        str: 			                "ﱘ";
        border-radius:                  100%;
        background-color:               @BG;
        text-color:                     @FG;
        padding:                        8px 12px 8px 12px;
        font:			                "Iosevka Nerd Font 10";
    }
    
    entry {
        background-color:               @BG;
        text-color:                     @FG;
        placeholder-color:              @FG;
        expand:                         true;
        horizontal-align:               0;
        placeholder:                    "Search...";
        blink:                          true;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
        padding:                        8px;
    }
    
    inputbar {
        children: 			            [ textbox-prompt-colon, prompt ];
        background-color:               @BG;
        text-color:                     @FG;
        expand:                         false;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  0px;
        border-color:                   @BDR;
        margin:                         0px 0px 0px 0px;
        padding:                        0px;
        position:                       center;
    }
    
    case-indicator {
        background-color:               @BG;
        text-color:                     @FG;
        spacing:                        0;
    }
    
    
    listview {
        background-color:               @BG;
        columns:                        3;
        lines:			                2;
        spacing:                        15px;
        cycle:                          false;
        dynamic:                        true;
        layout:                         vertical;
    }
    
    mainbox {
        background-color:               @BG;
        children:                       [ inputbar, listview ];
        spacing:                        15px;
        padding:                        15px;
    }
    
    element {
        background-color:               @BGA;
        text-color:                     @SEL;
        orientation:                    horizontal;
        border-radius:                  10px;
        padding:                        8px;
    }
    
    element-icon {
        background-color: 		        inherit;
        text-color:       		        inherit;
        size:                           0px;
        border:                         0px;
    }
    
    element-text {
        background-color: 		        inherit;
        text-color:       		        inherit;
        expand:                         true;
        horizontal-align:               0.5;
        vertical-align:                 0.5;
        margin:                         2px 0px 0px 0px;
    }
    
    element selected {
        background-color:               @IMG;
        text-color:                     @BG;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  10px;
        border-color:                   @BDR;
    }
    
    element.active,
    element.selected.urgent {
      background-color: @ON;
      text-color: @BG;
      border-color: @ON;
    }
    
    element.selected.urgent {
      border-color: @BDR;
    }
    
    element.urgent,
    element.selected.active {
      background-color: @OFF;
      text-color: @BG;
      border-color: @OFF;
    }
    
    element.selected.active {
      border-color: @BDR;
    }
  '';

  xdg.configFile."rofi/network.rasi".text = ''
    configuration {
        show-icons:                     false;
        display-drun: 		            "";
        drun-display-format:            "{icon} {name}";
        disable-history:                false;
        click-to-exit: 		            true;
        location:                       0;
    }
    
    @import "font.rasi"
    @import "colors.rasi"
    
    window {
        transparency:                   "real";
        background-color:               @BG;
        text-color:                     @FG;
        border:                         2px;
        border-color:                   @BDR;
        border-radius:                  10px;
        width:                          300px;
        anchor:                         center;
        x-offset:                       0;
        y-offset:                       0;
    }
    
    prompt {
        enabled: 			            true;
        margin: 			            0px 0px 0px 8px;
        padding: 			            8px;
        background-color: 		        @BG;
        text-color: 		            @FG;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
    }
    
    textbox-prompt-colon {
        expand: 			            false;
        str: 			                "";
        border-radius:                  100%;
        background-color:               @BG;
        text-color:                     @FG;
        padding:                        8px 12px 8px 12px;
        font:			                "Iosevka Nerd Font 10";
    }
    
    entry {
        background-color:               @BG;
        text-color:                     @FG;
        placeholder-color:              @FG;
        expand:                         true;
        horizontal-align:               0;
        placeholder:                    "Search...";
        blink:                          true;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
        padding:                        8px;
    }
    
    inputbar {
        children: 			             [textbox-prompt-colon, prompt ];
        background-color:               @BG;
        text-color:                     @FG;
        expand:                         false;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  0px;
        border-color:                   @BDR;
        margin:                         0px 0px 0px 0px;
        padding:                        0px;
        position:                       center;
    }
    
    case-indicator {
        background-color:               @BG;
        text-color:                     @FG;
        spacing:                        0;
    }
    
    
    listview {
        background-color:               @BG;
        columns:                        1;
        lines:			                4;
        spacing:                        4px;
        cycle:                          true;
        dynamic:                        true;
        layout:                         vertical;
    }
    
    mainbox {
        background-color:               @BG;
        children:                       [ inputbar, listview ];
        spacing:                        15px;
        padding:                        15px;
    }
    
    element {
        background-color:               @BG;
        text-color:                     @FG;
        orientation:                    horizontal;
        border-radius:                  10px;
        padding:                        6px 6px 6px 6px;
    }
    
    element-icon {
        background-color: 		        inherit;
        text-color:       		        inherit;
        size:                           0px;
        border:                         0px;
    }
    
    element-text {
        background-color: 		        inherit;
        text-color:       		        inherit;
        expand:                         true;
        horizontal-align:               0;
        vertical-align:                 0.5;
        margin:                         2px 0px 2px 6px;
    }
    
    element selected {
        background-color:               @IMG;
        text-color:                     @BG;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  10px;
        border-color:                   @BDR;
    }
    
    element.active,
    element.selected.urgent {
      background-color: @ON;
      text-color: @BG;
      border-color: @ON;
    }
    
    element.selected.urgent {
      border-color: @BDR;
    }
    
    element.urgent,
    element.selected.active {
      background-color: @OFF;
      text-color: @BG;
      border-color: @OFF;
    }
    
    element.selected.active {
      border-color: @BDR;
    }
  '';

  xdg.configFile."rofi/networkmenu.rasi".text = ''
    configuration {
        show-icons:                     false;
        display-drun: 		            "";
        drun-display-format:            "{icon} {name}";
        disable-history:                false;
        click-to-exit: 		            true;
        location:                       0;
    }
    
    @import "font.rasi"
    @import "colors.rasi"
    
    window {
        transparency:                   "real";
        background-color:               @BG;
        text-color:                     @FG;
        border:                         2px;
        border-color:                   @BDR;
        border-radius:                  10px;
        width:                          400px;
        anchor:                         center;
        x-offset:                       0;
        y-offset:                       0;
    }
    
    prompt {
        enabled: 			            true;
        margin: 			            0px 8px 0px 8px;
        padding: 			            8px;
        background-color: 		        @IMG;
        text-color: 		            @BG;
        border:                  	    0px 0px 0px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
    }
    
    textbox-prompt-colon {
        expand: 			            false;
        str: 			                "直";
        border-radius:                  100%;
        background-color:               @SEL;
        text-color:                     @FG;
        padding:                        8px 12px 8px 12px;
        font:			                "Iosevka Nerd Font 10";
    }
    
    entry {
        background-color:               @BG;
        text-color:                     @FG;
        placeholder-color:              @FG;
        expand:                         true;
        horizontal-align:               0;
        placeholder:                    "";
        blink:                          true;
        border:                  	    0px 0px 2px 0px;
        border-color:                   @BDR;
        border-radius:                  10px;
        padding:                        8px;
    }
    
    inputbar {
        children: 		                [ textbox-prompt-colon, prompt, entry ];
        background-color:               @BG;
        text-color:                     @FG;
        expand:                         false;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  0px;
        border-color:                   @BDR;
        margin:                         0px 0px 0px 0px;
        padding:                        0px;
        position:                       center;
    }
    
    case-indicator {
        background-color:               @BG;
        text-color:                     @FG;
        spacing:                        0;
    }
    
    
    listview {
        background-color:               @BG;
        columns:                        1;
        lines:			                7;
        spacing:                        4px;
        cycle:                          true;
        dynamic:                        true;
        layout:                         vertical;
    }
    
    mainbox {
        background-color:               @BG;
        children:                       [ inputbar, listview ];
        spacing:                        15px;
        padding:                        15px;
    }
    
    element {
        background-color:               @BG;
        text-color:                     @FG;
        orientation:                    horizontal;
        border-radius:                  4px;
        padding:                        6px 6px 6px 6px;
    }
    
    element-icon {
        background-color: 	            inherit;
        text-color:       		        inherit;
        size:                           0px;
        border:                         0px;
    }
    
    element-text {
        background-color: 	            inherit;
        text-color:       		        inherit;
        expand:                         true;
        horizontal-align:               0;
        vertical-align:                 0.5;
        margin:                         2px 0px 2px 6px;
    }
    
    element normal.urgent,
    element alternate.urgent {
        background-color:               @UGT;
        text-color:                     @FG;
        border-radius:                  9px;
    }
    
    element normal.active,
    element alternate.active {
        background-color:               @BGA;
        text-color:                     @FG;
    }
    
    element selected {
        background-color:               @BGA;
        text-color:                     @SEL;
        border:                  	    0px 0px 0px 0px;
        border-radius:                  10px;
        border-color:                   @BDR;
    }
    
    element selected.urgent {
        background-color:               @UGT;
        text-color:                     @FG;
    }
    
    element selected.active {
        background-color:               @BGA;
        color:                          @FG;
    }
  '';
}
