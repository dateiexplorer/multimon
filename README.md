# multimon
Change between different single-/ multi-monitor setups on the fly in bspwm.

# Usage 
Make sure, you clone or move this repository to the ```~/.config/multimon``` 
directory.

The scripts ```multimon``` and ```multimond``` need execution privileges:

```
cd ~/.config/multimon
chmod +x multimon multimond 
```

All the scripts doesn't need superuser privileges.

Then you can run ```~/.config/multimon/multimon``` to apply automatically a 
setups, which must be defined before in ```~/.config/multimon/setups```.

A setup configuration example for my current monitor setup looks like this:

```
[DisplayPort-1]
device=27G2G5
desktops=1,2,3,4,5
geometry=1920x1080+0+0
rotation=normal
flags=
polybar=generic

[HDMI-A-1]
device=MD20581
desktops=5,6,7,8,9,10
geometry=1920x1080+1920+0
rotation=normal
flags=primary
polybar=primary
```

If the corresponding monitors are connected with it's outputs, this setup will
automatically applied. To apply manually a setup (in this example the file is
named 'default'), you could run:

```
~/.config/multimon/multimon default.
```

# The multimon daemon (multimond)
The multimon deamon ```~/.config/multimon/multimond``` is a script, that will
execute automatically, if you use multimon.
It listen to the bspc add_monitor event and manages the new connections.

You'll never need to run this script manually.

# Polybar support
The scripts support polybar. To apply a polybar, add in the setup configuration
the attribute ```polybar``` and define the name of the bar, you want to apply.
Make your polybar configurations in the default polybar configuration
directories. Make also sure, that you've installed polybar on your system.
