#!/bin/bash

SETUP_HOME="$HOME/.config/multimon/setups"

source "$HOME/.config/multimon/tools/multimon_utils.sh"

setup="$1"

if [ ! -f "$SETUP_HOME/$setup" ]; then
    echo "Setup '$setup' not found."
    exit
fi

# Setup is available. Check if the setup matches the connected monitors.
connected_mon_names=$(xrandr --query | grep -w "connected" | awk '{ print $1 }')

# Get the configured monitos.
configured_mon_names=$(get_configured_monitors "$SETUP_HOME/$setup")

if [[ $(configured_in_connected "$connected_mon_names" \
	"$configured_mon_names") ]]; then
    echo "A monitor is configured but not connected." 
    exit
fi

# All monitors to configure are connected.
# Apply setup.

if [[ -L "$SETUP_HOME/current" ]]; then
    rm "$SETUP_HOME/current"
fi

ln -s "$SETUP_HOME/$setup" "$SETUP_HOME/current"
echo "Setup '$setup' is set as 'current'."
