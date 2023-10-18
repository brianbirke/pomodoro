{
  description = "Pomodoro - starting a timer for 25 minuttes.";

  inputs = {
        nixpkgs = {
		      url = "nixpkgs/nixos-23.05";
	      };
        nixpkgs_unstable = {
	        url = "github:NixOS/nixpkgs/nixos-unstable";
	      };

        flake-utils.url = "github:numtide/flake-utils";
  };


  outputs = {
    self,
    nixpkgs,
    nixpkgs_unstable,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      pkgs_unstable = import nixpkgs_unstable {
        inherit system;
      };


     shelly = pkgs.mkShell {
        buildInputs = [
         pkgs.mplayer 
         pkgs.termdown 
        ];
        shellHook = ''
          export PS1="pomodoro) \h:\w]\$\[\033[0m\] "
            '';
      };
 
      termdown = "${pkgs.termdown}/bin/termdown";
      mplayer = "${pkgs.mplayer}/bin/mplayer";
      mySound = builtins.path {
        path = ./bells/old-car-engine_daniel_simion.mp3;
        name = "mySound";
      };

      timer = 
        pkgs.writeScriptBin "start" ''
           ${termdown} --font doh 25m && ${mplayer} ${mySound} 
          '';

    in {
    
      apps.default = {
        type = "app";
        program = "${timer}/bin/start";
      };

      apps.timer.start = {
        type = "app";
        program = "${timer}/bin/start";
      };

      devShells.default = shelly;

    });
}



