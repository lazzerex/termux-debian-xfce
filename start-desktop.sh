#!/data/data/com.termux/files/usr/bin/bash
# starts Termux:X11 and launches XFCE inside proot-distro Debian
pkill -f termux.x11 2>/dev/null
pulseaudio --start --exit-idle-time=-1 \
  --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1"
termux-x11 :0 >/dev/null 2>&1 &
sleep 3
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
proot-distro login debian --shared-tmp --user droid -- \
  env DISPLAY=:0 PULSE_SERVER=127.0.0.1 \
  dbus-launch --exit-with-session startxfce4
