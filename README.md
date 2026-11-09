# Debian XFCE Desktop on Android (Termux + proot-distro)

Run a full Debian desktop (XFCE) on an Android phone, no root required, using Termux, proot-distro and Termux:X11.

Tested on: ZTE Blade A54, Debian 13 (trixie), aarch64. Needs about 3-4 GB of storage and 4 GB RAM or more is recommended.

## Requirements

- [Termux](https://github.com/termux/termux-app/releases) from F-Droid or GitHub (not the Play Store version)
- [Termux:X11 app](https://github.com/termux/termux-x11/releases) (nightly APK)

## 1. Prepare Termux

```bash
pkg update && pkg upgrade -y
pkg install x11-repo proot-distro -y
pkg install termux-x11-nightly pulseaudio -y
```

## 2. Install Debian

```bash
proot-distro install debian
proot-distro login debian
```

Inside Debian:

```bash
apt update && apt upgrade -y
DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-terminal dbus-x11 sudo nano firefox-esr fastfetch
adduser droid
usermod -aG sudo droid
exit
```

## 3. Add the start script

Copy `start-desktop.sh` from this repo into Termux's home folder, then:

```bash
chmod +x ~/start-desktop.sh
```

## 4. Launch

```bash
~/start-desktop.sh
```

Open the Termux:X11 app. The first launch can take 10-30 seconds to show the desktop.

## Exit

1. In XFCE: **Applications menu > Log Out**
2. In Termux:

```bash
pkill -f termux.x11
pulseaudio --kill
```

Terminal only, no desktop:

```bash
proot-distro login debian --user droid
```

## Recommended tweaks

- Acquire the Termux **wakelock** from its notification, and set Termux and Termux:X11 to "Unrestricted" battery use.
- On Android 12+, disable the "phantom process killer" if the desktop closes randomly.
- Remove the screen locker, which can lock you out: `sudo apt remove -y light-locker`
- Firefox crashing? Run `MOZ_FAKE_NO_SANDBOX=1 firefox-esr`
- Use Termux:X11 "Trackpad" touch mode, or a Bluetooth mouse and keyboard.

## Customizing the look

**Terminal prompt** (add to `~/.bashrc` inside Debian):

```bash
PS1='\[\e[32m\]user@debian\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '
```

**Fastfetch**: set up the config, then personalize it.

```bash
mkdir -p ~/.config/fastfetch
cp fastfetch-config.jsonc ~/.config/fastfetch/config.jsonc
nano ~/.config/fastfetch/config.jsonc
```

Replace these placeholders in the file:

| Placeholder | Replace with | Example |
|---|---|---|
| `YOUR_NAME@YOUR_HOSTNAME` | The title line at the top | `alex@debian` |
| `YOUR_PHONE_MODEL` | Your phone's name | `Samsung Galaxy A54` |

Optional edits:
- Change `"keys": "red"` to `blue`, `green`, `cyan`, `yellow` or `magenta`.
- Delete any line (such as `"swap"`) to hide that module.
- Adjust the dashed separator line so it matches your title length.

Save with Ctrl+O, Enter, Ctrl+X, then run `fastfetch` to preview. The title and Device lines are plain text; everything else is read from your system. To show it on every new terminal, add `fastfetch` to the end of `~/.bashrc`.

## Troubleshooting

| Problem | Fix |
|---|---|
| Permission denied running the script | `chmod +x ~/start-desktop.sh` |
| Black screen or "cannot open display" | Make sure `dbus-x11` is installed and the script uses `--shared-tmp` |
| "X server already running" | `pkill -f termux.x11`, then rerun the script |
| No sound | Check `pulseaudio --check` in Termux |
| systemd / D-Bus / `_NET_*` warnings | Normal under proot, safe to ignore |
| Laggy | Lower the resolution in Termux:X11 preferences, or use LXQt (`apt install lxqt`, run `startlxqt`) |

## License

MIT
