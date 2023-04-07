{
  description = "A very basic flake";

  inputs = {
  	
  	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  
    home-manager = {
		  url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
		};
    
    nur = {
		  url = "github:nix-community/NUR";
		};
    
    hyprland = {
		  url = "github:hyprwm/Hyprland";
		  inputs.nixpkgs.follows = "nixpkgs";
		};

    nix-matlab = {
      #inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };

        
	};

  outputs = {self, nixpkgs, nur, home-manager, hyprland, nix-matlab, ... } @ inputs : 
  
  let

		user = "molaco";
    flake-overlays = [
      nix-matlab.overlay
    ];


	in {

		nixosConfigurations = (
			
			import ./hosts {
				inherit (nixpkgs) lib;
				inherit inputs nixpkgs home-manager nur user hyprland flake-overlays;
				}

			);
		};
	}
