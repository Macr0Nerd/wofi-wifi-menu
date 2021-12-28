#!/usr/bin/env bash

# this prints a beautifully formatted list. bash was a mistake
nmcli -t d wifi rescan
LIST=$(nmcli --fields SSID,SECURITY,BARS device wifi list | sed '/^--/d' | sed 1d | sed -E "s/WPA*.?\S/~~/g" | sed "s/~~ ~~/~~/g;s/802\.1X//g;s/--/~~/g;s/  *~/~/g;s/~  */~/g;s/_/ /g" | column -t -s '~')

# get current connection status
CONSTATE=$(nmcli -fields WIFI g)
if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE="Disable WiFi 睊"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="Enable WiFi 直"
fi

# display menu; store user choice
CHENTRY=$(echo -e "$TOGGLE\n$LIST" | uniq -u | rofi -dmenu -selected-row 1 -config "./theme.rasi")
# store selected SSID
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

if [ "$CHENTRY" = "" ]; then
    exit
elif [ "$CHENTRY" = "Enable WiFi 直" ]; then
	nmcli radio wifi on
elif [ "$CHENTRY" = "Disable WiFi 睊" ]; then
	nmcli radio wifi off
else
    # get list of known connections
    KNOWNCON=$(nmcli connection show)
	
	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "" ]]; then
			WIFIPASS=$(echo " Press Enter if network is saved" | rofi -dmenu -p " WiFi Password: " -lines 1 )
		fi
		if nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
		then
			notify-send 'Connection successful'
		else
			notify-send 'Connection failed'
		fi
	fi
fi
