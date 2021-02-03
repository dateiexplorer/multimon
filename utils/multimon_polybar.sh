#!/bin/bash

source "$HOME/.config/multimon/utils/multimon_utils.sh"

config_file="$1"

# Check if polybar ist installed on the system.
if command -v polybar &> /dev/null; then
    
    # Destroy all running instances of polybar.	
    killall -q polybar

    while pgrep -u $UID -x polybar; do sleep 1; done

    # Create a polybar for each monitor based on the configuration.
    mons=$(polybar --list-monitors | sed 's/:.*//g')
    for mon in $mons; do
        cur_config=$(get_config_for_monitor "$config_file" "$mon")
	bar=$(echo "$cur_config" | grep "polybar" | sed 's/.*=//')
	
	if [ -n "$bar" ]; then
            echo "Add polybar '$bar' for monitor '$mon'."
	    MONITOR="$mon" polybar --quiet --reload "$bar" & 
        fi
    done
fi
