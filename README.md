# wofi-wifi-menu
*Forked from [vlfldr](https://github.com/vlfldr/rofi-wifi-menu)*

A small and configurable wifi menu for swaywm. Written in bash. Uses wofi and nmcli.
In addition to the original project's dependencies (bash, nmcli, wofi), this script uses:
* notify-send to display success/failure notification on connection


**This fork's goals:**
* Make rofi-wifi-menu work with wofi

**This forks' limitations:**
* Width needs to manually bumped up based on longest SSID. Sorry :(
* No manual SSID entry
* WEP networks not tested
* Nerd Fonts interfere with Font Awesome.
FA conversion coming soon.

### Configuration & Styling
To configure, copy the config files and stylesheets to ~/.config/wofi-wifi-menu.
This directory will have to be created.
Can be styled and configured like a regular wofi menu.
