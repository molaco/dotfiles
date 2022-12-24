{ lib, inputs, nixpkgs, home-manager, nur, user, hyprland, ... }:

let
	system = "x86_64-linux";

	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
		};

	lib = nixpkgs.lib;

in {
	laptop = lib.nixosSystem {
		inherit system;
		specialArgs = { inherit inputs user; };
		modules = [
			nur.nixosModules.nur
			hyprland.nixosModules.default
			./laptop

			home-manager.nixosModules.home-manager {
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.extraSpecialArgs = { inherit user; };
				home-manager.users.${user} = {
					imports = [(import ./laptop/home.nix)];
					};
				nixpkgs = {
        		  		overlays = [
        					(final: prev: {
        						catppuccin-cursors = prev.callPackage ../overlays/catppuccin-cursors.nix { };
        			      catppuccin-gtk = prev.callPackage ../overlays/catppuccin-gtk.nix { };
                    catppuccin-folders = prev.callPackage ../overlays/catppuccin-folders.nix {};
                    clisp = prev.clisp.override {
                    # On newer readline8 fails as:
                    #  #<FOREIGN-VARIABLE "rl_readline_state" #x...>
                    #   does not have the required size or alignment
                    readline = pkgs.readline6;
                    };

        			    			})
        			  		];
        				};
				}

			];
		};
	}
