#!/usr/bin/env fish

# Get the script's own process ID to prevent self-termination
set script_pid (pgrep -x fish | tail -n 1)

# List of important processes to keep running (add or remove as needed)
set important_processes \
    "systemd" \
    "fish" \
    "sshd" \
    "bash" \
    "dbus-daemon" \
    "NetworkManager" \
    "Xorg" \
    "pulseaudio" \
    "pipewire" \
    "pipewire-media-session" \
    "Xwayland" \
    "wayland" \
    "gnome-shell" \
    "sway" \
    "weston" \
    "kwin_x11" \
    "plasmashell" \
    $script_pid

# Iterate over all user processes
for pid in (ps -u (whoami) -o pid,comm | tail -n +2 | awk '{print $1}')
    set process_name (ps -p $pid -o comm=)

    # If the process is not in the list of important processes, kill it
    if not contains $process_name $important_processes
        echo "Killing $process_name (PID: $pid)"
        kill -9 $pid
    end
end
