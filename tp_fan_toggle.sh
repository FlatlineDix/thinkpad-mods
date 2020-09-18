#!/bin/bash

# tp_fan_toggle.sh
# ----------------
#  Simple script to toggle fan speed for thinkpad laptops from auto to
#    full-speed.  Need sudo or custom group made to access /proc/acpi 
#    Also needs fan_control=1 in thinkpad_acpi kmod options.
#
#   created 2019-11-21

# bail on any error
set -e 

# cur_speed doesn't need elevated priv
cur_speed="$(cat /proc/acpi/ibm/fan |  grep -i "level:" | awk '{print $2}')";
swap_speed="auto";  # the default if fan is set to a numbered setting

# check the current speed and swap if necessary
if [[ "$cur_speed" == "auto" ]]; then
    swap_speed="full-speed";
fi

            # forward to /dev/null expecting you to have notify-send
            # else, remove i/o redirect (redirect should be optional in case
            # end-user isn't running script in a WM/GUI env
echo "level $swap_speed" | sudo tee /proc/acpi/ibm/fan \
&& notify-send -i computer "Changed fan speed to "$swap_speed;

