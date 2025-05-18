# https://github.com/marlonrichert/zsh-autocomplete
skip_global_compinit=1

# This seems to point to a location like this without modifying it here:
# unix:path=/tmp/dbus-b5npKcBnGt,guid=8097c3db01ecabad106247206827b078
# which is incompatible with commands like podman run
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
