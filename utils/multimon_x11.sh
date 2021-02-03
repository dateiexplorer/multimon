#!/bin/bash

source "$HOME/.config/multimon/utils/multimon_utils.sh"

apply_flag() {
    cur_mon="$1"
    flag="$2"

    case "$flag" in
        "primary")
	    xrandr --output "$cur_mon" --primary
	;;
    esac
}

configure_monitors() {
    config_file="$1"

    # Get all connected monitors
    connected_monitor_names=$(xrandr --query | grep -w "connected" \
	    | awk '{ print $1 }' ) &> /dev/null
    for mon in $connected_monitor_names; do
        cur_config=$(get_config_for_monitor "$config_file" "$mon")
    
        # If there's no configuration available for the connected monitor, 
	# disconnect it. 
        if [[ -z "$cur_config" ]]; then
	    xrandr --output "$mon" --off &> /dev/null
            continue
        fi 
    
        # A Configuration for the monitor exists.

        flags=$(echo "$cur_config" | grep "flags" | sed 's/.*=//;s/,/ /g')
        for flag in $flags; do
            apply_flag "$mon" "$flag"
        done
    
        geometry=$(echo "$cur_config" | grep "geometry" \
		| sed 's/.*=//;s/[x+]/ /g') > /dev/null
        rotation=$(echo "$cur_config" | grep "rotation" \
		| sed 's/.*=//') &> /dev/null

        case "$rotation" in
            "normal"|"inverted")
	        mode=$(awk '{ printf $1 "x" $2 }' <<< "$geometry") &> /dev/null
	        ;;
	    "right"|"left")
	        mode=$(awk '{ printf $2 "x" $1 }' <<< "$geometry") &> /dev/null
	        ;;
        esac

        position=$(awk '{ printf $3 "x" $4 }' <<< "$geometry") &> /dev/null

        xrandr --output "$mon" --mode "$mode" --pos "$position" \
		--rotation "$rotation" &> /dev/null 
    done
}
