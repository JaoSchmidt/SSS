# xfce4-panel --disable-wm-check
xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal
xrandr --output DP-0 --right-of HDMI-0 --mode 1366x768

#[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

#xset +fp /home/jaoschmidt/.local/share/fonts
#xset fp rehash

#executa script fehbg
~/.local/share/fehbg

#inicia status bar
/usr/local/bin/dwmblocks &
exec dwm
