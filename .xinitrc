# xfce4-panel --disable-wm-check
xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal
xrandr --output DP-0 --mode 1366x768

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

~/.local/share/fehbg
exec dwm
