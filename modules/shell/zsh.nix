{ pkgs, lib, ... }:

{
	programs = {
		zsh = {
          		enable = true;
          		enableCompletion = true;
          		enableAutosuggestions = true;
         		dotDir = ".config/zsh";
         		history = {
         	   		save = 10000;
         	   		size = 10000;
         	 		};

			initExtra = ''
	      			bindkey -v
				bindkey "^R" history-beginning-search-backward
				zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
				if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
					exec Hyprland
		      		fi
				autoload -U up-line-or-beginning-search
				autoload -U down-line-or-beginning-search
				zle -N up-line-or-beginning-search
				zle -N down-line-or-beginning-search
				bindkey "^[[A" up-line-or-beginning-search # Up
				bindkey "^[[B" down-line-or-beginning-search # Down
	      			'';
  
        		plugins = with pkgs; [
					{
        					name = "zsh-vi-mode";
        					src = zsh-vi-mode;
        					file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      					}
					{
      						  name = "fzf-tab";
      						  file = "fzf-tab.plugin.zsh";
      						  src = fetchFromGitHub {
      						    owner = "Aloxaf";
      						    repo = "fzf-tab";
      						    rev = "426271fb1bbe8aa88ff4010ca4d865b4b0438d90";
      						    sha256 = "sha256-RXqEW+jwdul2mKX86Co6HLsb26UrYtLjT3FzmHnwfAA=";
      						  };
      					}
					{
      						name = "fast-syntax-highlighting";
      						file = "fast-syntax-highlighting.plugin.zsh";
      						src = fetchFromGitHub {
      							owner = "zdharma-continuum";
      					    		repo = "fast-syntax-highlighting";
      					    		rev = "7c390ee3bfa8069b8519582399e0a67444e6ea61";
      					    		sha256 = "sha256-wLpgkX53wzomHMEpymvWE86EJfxlIb3S8TPy74WOBD4=";
      					  		};
      					}
      					{
      						name = "zsh-autopair";
      					  	file = "zsh-autopair.plugin.zsh";
      					  	src = fetchFromGitHub {
      					    		owner = "hlissner";
      					    		repo = "zsh-autopair";
      					    		rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
      					    		sha256 = "sha256-PXHxPxFeoYXYMOC29YQKDdMnqTO0toyA7eJTSCV6PGE=";
      					  		};
      						}
				];

      			};

		starship = {
			enable = true;
			enableZshIntegration = lib.mkDefault true;
			settings = {
				format = "[ ❄️](bold yellow) $directory(bold blue)$git_branch$git_status[\\$](bold) ";
				directory = {
        				style = "bold blue";
					};
				status = {
      					disabled = false;
      			  		format = "[$symbol $status]($style) ";
      			  		not_found_symbol = "";
      			  		not_executable_symbol = "";
      			  		sigint_symbol = "ﭦ";
      			  		map_symbol = true;
      					};
				git_branch = {
        				format = "[$symbol$branch]($style) ";
					};
				};
			};

    		};
  	}
