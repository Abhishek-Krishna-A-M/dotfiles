#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
export XDG_CURRENT_DESKTOP=uwm
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export LIBVA_DRIVER_NAME=i965
export VDPAU_DRIVER=va_gl
export GTK_USE_PORTAL=0
export GTK_A11Y=none
