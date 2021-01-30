#!/bin/bash

SETUP_HOME="$HOME/.config/multimon/setups"
source "$HOME/.config/multimon/tools/multimon_utils.sh"

# Get current connected monitors and their edid
cur_edids=$(source "$HOME/.config/multimon/tools/multimon_edid.sh")

# Get all available setups
all_setups=$(ls "$SETUP_HOME" | grep -v "current")

if [[ -L "$SETUP_HOME/current" ]]; then 
    rm "$SETUP_HOME/current"
fi

# Check each setup, until a setup matches the current configuration.
for setup in $all_setups; do
    connected_mon_names=$(echo "$cur_edids" | awk '{ print $1 }')
    configured_mon_names=$(get_configured_monitors "$SETUP_HOME/$setup") 

    if [[ $(configured_in_connected "$connected_mon_names" \
	    "$configured_mon_names") ]]; then
        continue
    fi

    # Check if a entry exists for the current connections. 
    for mon in $connected_mon_names; do
	# Get the configuration for the monitor in the current setup.
	# This might be NULL.
        mon_config=$(get_config_for_monitor "$SETUP_HOME/$setup" "$mon")
        
	# Get the edid of this monitor from the configuration. This might be 
	# NULL.
	mon_edid=$(echo "$mon_config" | grep "device" | sed 's/.*=//') \
		&> /dev/null
         
        # Check if this edid equals the edid of the corresponding connected 
	# monitor.
        # If not, the monitor is not configured for this device in the current
        # setup -> continue with the next setup	
	if [[ -z "$mon_edid" ]] || [[ "$(echo "$cur_edids" | grep -w "$mon" \
		| awk '{ print $2 }')" != "$mon_edid" ]]; then
	    continue 2 
	fi

    done

    # If all monitors form this setup matches the current connected monitos,
    # set this as default.
    ln -s "$SETUP_HOME/$setup" "$SETUP_HOME/current"
    echo "Automatically detected setup: $setup"
    break
done

if [[ ! -f "$SETUP_HOME/current" ]]; then
    echo "No setup matches the current connections."
fi
