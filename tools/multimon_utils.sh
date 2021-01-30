#!/bin/bash

get_configured_monitors() {
    config_file="$1"
    echo "$(grep '^\[.*]$' < "$config_file" | sed 's/[][]//g')"
}

get_config_for_monitor() {
    config_file="$1"
    cur_mon_name="$2"

    echo "$(sed -nE "/^\[$cur_mon_name\]$/{:l n;/^(\{.*\])?$/q;p;bl}" \
	    "$config_file")"
}

configured_in_connected() {
    connected_mon_names="$1"
    configured_mon_names="$2"

    for mon in $configured_mon_names; do
        if [ -z $(echo "$connected_mon_names" | grep "$mon") ]; then
	   echo "Monitor $mon is configured but not connected."
	   return;
        fi	
    done
}
