# multimon
Change between different single-/ multi-monitor setups on the fly in bspwm.

# Usage 
Make sure, you clone or move this repository to the ```~/.config/multimon``` 
directory.

All the scripts (multimon, multimond and the .sh scripts in the tools
directory) needed execution privileges:

```
cd ~/.config/multimon
chmod +x multimon multimond tools/*
```

All the scripts doesn't need superuser privileges.

Then you can run ```~/.config/multimon/multimon``` to apply automatically a 
setups, which must be defined in ```~/.config/multimon/setups```.

A setup configuration example for my current monitor setup looks like this:

```
[DisplayPort-1]
device=27G2G5
desktops=1,2,3,4,5
geometry=1920x1080+0+0
rotation=normal
flags=

[HDMI-A-1]
device=MD20581
desktops=5,6,7,8,9,10
geometry=1920x1080+1920+0
rotation=normal
flags=primary

```

If the corresponding monitors are connected with it's outputs, this setup will
automatically applied. To apply manually a setup (in this example the file is
named 'default'), you could run:

```
~/.config/multimon/multimon default.
```

# Detect connected monitors
To get information about your connected monitors (especially for the 
```device``` attribute), you can run the 
```~/.config/multimon/tools/multimon_edid.sh``` script.

# The multimon daemon
The multimon deamon ```~/.config/multimon/multimond``` is a script, that will
execute automatically, if you use multimon for the first time.
It listen to the bspc add_monitor event and manages the new connections.

You'll never need to run this script manually.
