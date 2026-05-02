#!/usr/bin/env bash

# ── ANSI ────────────────────────────────────────────
ESC=$'\033'
R="${ESC}[0m"
DIM="${ESC}[2m"
BOLD="${ESC}[1m"
_c() { printf "${ESC}[38;5;%sm" "$1"; }

L0="$(_c 24)${DIM}"  # dim punctuation
L1="$(_c 33)"         # o
L2="$(_c 69)"         # i j I
L3="$(_c 75)"         # x
L4="$(_c 117)"        # k

A="$(_c 75)"          # label accent
V="$(_c 252)"         # value
U="$(_c 255)${BOLD}"  # user@host
S="$(_c 238)"         # dim/sep

# ── Colorize logo chars ──────────────────────────────
colorize() {
    local line="$1" out="" ch i=0
    while (( i < ${#line} )); do
        ch="${line:i:1}"
        case "$ch" in
            '/')  out+="${L3}/${R}" ;;
            '\')  out+="${L3}\\${R}" ;;
            '|')  out+="${L1}|${R}" ;;
            '_')  out+="${L4}_${R}" ;;
            "'")  out+="${L2}'${R}" ;;
            *)    out+="$ch" ;;
        esac
        (( i++ ))
    done
    printf '%s' "$out"
}

# ── Logo ─────────────────────────────────────────────
mapfile -t RAW_LOGO <<'LOGO'
    _    _  __
   / \  | |/ /
  / _ \ | ' / 
 / ___ \| . \ 
/_/   \_\_|\_\
LOGO

LOGO_LINES=(); LOGO_MAX=0
for raw in "${RAW_LOGO[@]}"; do
    LOGO_LINES+=("$(colorize "$raw")")
    (( ${#raw} > LOGO_MAX )) && LOGO_MAX=${#raw}
done
LOGO_PAD=$(( LOGO_MAX + 3 ))
# ── Data ─────────────────────────────────────────────
USER_NAME="${USER:-$(whoami)}"
HOST_NAME="${HOSTNAME:-$(hostname -s)}"

OS=$(grep -oP '(?<=^PRETTY_NAME=).+' /etc/os-release 2>/dev/null | tr -d '"')
KERNEL=$(uname -r)

up=$(cut -d. -f1 /proc/uptime)
UP_H=$(( up/3600 )); UP_M=$(( (up%3600)/60 ))
(( UP_H > 0 )) && UPTIME="${UP_H}h ${UP_M}m" || UPTIME="${UP_M}m"

if   command -v pacman &>/dev/null; then PKGS="$(pacman -Q 2>/dev/null | wc -l) ${S}(pacman)${R}"
elif command -v dpkg   &>/dev/null; then PKGS="$(dpkg-query -f '.\n' -W 2>/dev/null | wc -l) ${S}(dpkg)${R}"
elif command -v rpm    &>/dev/null; then PKGS="$(rpm -qa 2>/dev/null | wc -l) ${S}(rpm)${R}"
else PKGS="unknown"; fi

SH_NAME=$(basename "$SHELL")
SH_VER=$(${SHELL} --version 2>&1 | grep -oP '\d+\.\d+[\.\d]*' | head -1)
SHELL_INFO="${SH_NAME} ${S}${SH_VER}${R}"

TERM_INFO="${TERM:-unknown}"

# WM — env var first, then xprop fallback
_wm="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}"
if [[ -z "$_wm" ]] && command -v xprop &>/dev/null; then
    _root=$(xprop -root _NET_SUPPORTING_WM_CHECK 2>/dev/null | grep -o '0x[0-9a-f]*')
    [[ -n "$_root" ]] && \
        _wm=$(xprop -id "$_root" _NET_WM_NAME 2>/dev/null | grep -oP '(?<= = ").*(?=")')
fi
case "${_wm,,}" in
    bspwm)      WM_ICON="󰕮" ;; i3|i3wm)   WM_ICON="󰕴" ;;
    openbox)    WM_ICON="󰆾" ;; xfce*)     WM_ICON="󰣙" ;;
    gnome)      WM_ICON="󰣇" ;; plasma)    WM_ICON="󰣚" ;;
    hyprland)   WM_ICON="󱣴" ;; sway)      WM_ICON="󰀆" ;;
    dwm)        WM_ICON="󰕲" ;; awesome)   WM_ICON="󰕰" ;;
    *)          WM_ICON="󰖲" ;;
esac
WM_INFO="${_wm:-unknown}"

CPU=$(grep -m1 'model name' /proc/cpuinfo \
    | sed 's/.*: //;s/(R)//g;s/(TM)//g;s/CPU //;s/  */ /g' | xargs)
CORES=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo)
CPU_INFO="${CPU} ${S}(${CORES})${R}"

GPU=$(lspci 2>/dev/null | grep -iE 'vga|3d|display' \
    | sed 's/.*: //;s/ (rev [0-9a-f]*)//;s/Corporation //;s/  */ /g' \
    | head -1 | xargs)
GPU_INFO="${GPU:-N/A}"

MT=$(awk '/MemTotal/    {print $2}' /proc/meminfo)
MA=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
MU=$(( MT - MA ))
gib() { awk "BEGIN{printf \"%.2f GiB\",$1/1048576}"; }
MEM_PCT=$(( MU * 100 / MT ))
bw=12; fill=$(( MEM_PCT * bw / 100 )); empty=$(( bw - fill ))
BAR="$(_c 114)$(printf '█%.0s' $(seq 1 $fill))${S}$(printf '░%.0s' $(seq 1 $empty))${R}"
MEM_INFO="${BAR} $(gib $MU) / $(gib $MT) ${S}(${MEM_PCT}%)${R}"

DISK=$(df -BG / 2>/dev/null | awk 'NR==2{
    u=$3; t=$2; p=$5; sub(/G/,"",u); sub(/G/,"",t)
    printf "%sG / %sG (%s)", u, t, p}')

read -r IP_ADDR IP_IFACE < <(
    ip -4 addr 2>/dev/null | awk '/inet / && !/127\.0\.0/{print $2, $NF; exit}')
IP_INFO="${IP_ADDR:-N/A} ${S}(${IP_IFACE:-?})${R}"

# replace your battery block with this
BATT_PATH=""
for _bp in /sys/class/power_supply/BAT{0,1,2}; do
    [[ -f "${_bp}/capacity" ]] && { BATT_PATH="$_bp"; break; }
done

if [[ -n "$BATT_PATH" ]]; then
    B_PCT=$(cat "${BATT_PATH}/capacity" 2>/dev/null | tr -d '[:space:]')
    B_STA=$(cat "${BATT_PATH}/status"   2>/dev/null | tr -d '[:space:]')
    B_STA="${B_STA,,}"   # bash built-in lowercase — no pipe needed
    case "$B_STA" in
        charging)    B_ICON="󰂄" ;;
        discharging) (( B_PCT <= 20 )) && B_ICON="󰁻" || B_ICON="󰁼" ;;
        full)        B_ICON="󰁹" ;;
        *)           B_ICON="󰂑" ;;
    esac
    BATT_INFO="${B_PCT}% ${S}(${B_STA})${R}"
else
    B_ICON="󰂑"; BATT_INFO="N/A"
fi


# ── Rows ─────────────────────────────────────────────
row() { printf "  ${A}%s  %-9s${R}%s" "$1" "$2" "$3"; }
sep() { printf "  ${S}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"; }

INFO=(
""
"  ${U}${USER_NAME}${R}${S}@${R}${U}${HOST_NAME}${R}"
"  ${S}$(printf '─%.0s' $(seq 1 $(( ${#USER_NAME} + ${#HOST_NAME} + 1 ))))${R}"
"$(row 󰣇  os        "${V}${OS}${R}")"
"$(row 󰒋  kernel    "${V}${KERNEL}${R}")"
"$(row 󱑓  uptime    "${V}${UPTIME}${R}")"
"$(row 󰏖  packages  "${V}${PKGS}")"
"$(sep)"
"$(row    shell     "${V}${SHELL_INFO}")"
"$(row 󰆍  terminal  "${V}${TERM_INFO}${R}")"
"$(row ${WM_ICON}  wm        "${V}${WM_INFO}${R}")"
"$(sep)"
"$(row 󰻠  cpu       "${V}${CPU_INFO}")"
"$(row 󰍛  gpu       "${V}${GPU_INFO}${R}")"
"$(row 󰘚  memory    "${MEM_INFO}")"
"$(row 󰋊  disk      "${V}${DISK}${R}")"
"$(sep)"
"$(row 󰛳  ip        "${V}${IP_INFO}")"
"$(row ${B_ICON}  battery   "${V}${BATT_INFO}")"
"  ${DOTS}"
)

# ── Render ───────────────────────────────────────────
echo
LOGO_ROWS=${#LOGO_LINES[@]}
INFO_ROWS=${#INFO[@]}
TOTAL=$(( LOGO_ROWS > INFO_ROWS ? LOGO_ROWS : INFO_ROWS ))
LOGO_OFFSET=$(( (TOTAL - LOGO_ROWS) / 2 ))

for (( i=0; i<TOTAL; i++ )); do
    logo_i=$(( i - LOGO_OFFSET ))
    if (( logo_i >= 0 && logo_i < LOGO_ROWS )); then
        raw="${RAW_LOGO[$logo_i]}"
        colored="${LOGO_LINES[$logo_i]}"
    else
        raw=""
        colored=""
    fi
    pad=$(( LOGO_PAD - ${#raw} ))
    printf "%s%${pad}s%s\n" "$colored" "" "${INFO[$i]:-}"
done
echo
