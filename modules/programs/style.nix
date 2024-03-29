let
  Logo = builtins.fetchurl rec {
    name = "Logo-${sha256}.svg";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
  };
in ''
  @define-color nord0 #2E3440;
  @define-color nord1 #3b4252;
  @define-color nord2 #434c5e;
  @define-color nord3 #4c566a;
  @define-color nord4 #d8dee9;
  @define-color nord5 #e5e9f0;
  @define-color nord6 #eceff4;
  * {
    border: none;
    border-radius: 0;
    min-height: 0;
    font-family: Material Design Icons, FiraMono;
    font-size: 13px;
  }
  
  window#waybar {
    background-color: @nord0;
    transition-property: background-color;
    transition-duration: 0.5s;
  }

  #window {
    border-radius: 4px;
    margin: 6px 3px;
    padding: 6px 12px;
    background-color: @nord2;
    color: @nord4;
    font-weight: bold;
  }

  #custom-logo {
    padding: 6px 3px;
    margin: 6px 3px;
    border-radius: 4px;
    background-color: @nord2;
    color: @nord4;
    font-weight: bold;
  }

  #workspaces {
    background-color: transparent;
    font-weight: bold;
  }
  #workspaces button {
    all: initial; /* Remove GTK theme values (waybar #1351) */
    min-width: 0; /* Fix weird spacing in materia (waybar #450) */
    box-shadow: inset 0 -3px transparent; /* Use box-shadow instead of border so the text isn't offset */
    padding: 6px 10px;
    margin: 6px 3px;
    border-radius: 4px;
    background-color: @nord1;
    color: @nord4;
    font-weight: bold;
  }
  #workspaces button.active {
    color: @nord5;
    background-color: @nord2;
  }
  #workspaces button:hover {
   box-shadow: inherit;
   text-shadow: inherit;
   color: @nord6;
   background-color: @nord3;
  }
  #workspaces button.urgent {
    background-color: #38383d;
  }
  #custom-swallow,
  #custom-power,
  #battery,
  #backlight,
  #pulseaudio,
  #network,
  #clock,
  #tray {
    border-radius: 4px;
    margin: 6px 3px;
    padding: 6px 12px;
    background-color: @nord2;
    color: #CFCFCF;
    font-weight: bold;
  }
  #custom-power {
    margin-right: 6px;
  }
  #battery {
    background-color: #3B3B3B;
  }
  @keyframes blink {
    to {
      background-color: #3B3B3B;
      color: #CFCFCF;
    }
  }
  .warning,
  .critical,
  .urgent,
  #battery.critical:not(.charging) {
    background-color: #3B3B3B;
    color: #CFCFCF;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  }
  #backlight {
    background-color: @nord2;
  }
  #pulseaudio.microphone {
    background-color: @nord2;
  }
  #pulseaudio {
    background-color: @nord2;
  }
  #network {
    background-color: @nord2;
  }
  #clock.date {
    background-color: @nord2;
  }
  #clock {
    background-color: @nord2;
  }
  #custom-power {
    background-color: @nord2;
  }
  tooltip {
    font-family: "Inter", sans-serif;
    border-radius: 8px;
    padding: 20px;
    margin: 30px;
  }
  tooltip label {
    font-family: "Inter", sans-serif;
    padding: 20px;
  }
''
