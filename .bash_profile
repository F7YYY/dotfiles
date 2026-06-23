##########################################################################################################################################################################
#        ________      ________      ________       ___  ___                     ________    ________      ________      ________  ___      ___           _______        #
#       |\   __  \    |\   __  \    |\   ____\     |\  \|\  \                   |\   __  \  |\   __  \    |\   __  \    |\  _____\|\  \    |\  \         |\  ___ \       #
#       \ \  \|\ /_   \ \  \|\  \   \ \  \___|_    \ \  \\\  \    ____________  \ \  \|\  \ \ \  \|\  \   \ \  \|\  \   \ \  \__/ \ \  \   \ \  \        \ \   __/|      #
#        \ \   __  \   \ \   __  \   \ \_____  \    \ \   __  \  |\____________\ \ \   ____\ \ \   _  _\   \ \  \\\  \   \ \   __\ \ \  \   \ \  \        \ \  \_|/__    #
#   ___   \ \  \|\  \   \ \  \ \  \   \|____|\  \    \ \  \ \  \ \|____________|  \ \  \___|  \ \  \\  \|   \ \  \\\  \   \ \  \_|  \ \  \   \ \  \____    \ \  \_|\ \   #
#  |\__\   \ \_______\   \ \__\ \__\    ____\_\  \    \ \__\ \__\                  \ \__\      \ \__\\ _\    \ \_______\   \ \__\    \ \__\   \ \_______\   \ \_______\  #
#  \|__|    \|_______|    \|__|\|__|   |\_________\    \|__|\|__|                   \|__|       \|__|\|__|    \|_______|    \|__|     \|__|    \|_______|    \|_______|  #
#                                      \|_________|                                                                                                                      #
#                                                                                                                                                                        #
##########################################################################################################################################################################
#
#   SCRIPTS
#
#   POSIX PORTABLE
#
#────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(EXPORT_ENVIRONMENT_VARIABLES)───
exporter() {
    INPUT=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
    ESCALATE=""
    ENVFILE="/etc/environment"
    PCI_DATA=$(lspci 2>/dev/null)
    PCI_LOWER=$(printf '%s' "$PCI_DATA" | tr '[:upper:]' '[:lower:]')
    VENDOR="unknown"

    #───(VARIABLES)
    ENLISTMENT="                            # LIST
HISTSIZE=1000
HISTFILESIZE=1000
HISTCONTROL=erasedups:ignoredups:ignorespace
EDITOR=vscodium-electron -w
GPG_TTY=$(tty 2>/dev/null)
_JAVA_AWT_WM_NONREPARENTING=1
XDG_SESSION_TYPE=${XDG_BACKEND:-}
#XDG_SESSION_DESKTOP=$XDG_CURRENT_DESKTOP   # DE/WM
#XDG_CURRENT_DESKTOP=$XDG_SESSION_DESKTOP   # DE/WM
CLUTTER_BACKEND=${XDG_BACKEND:-}
ECORE_EVAS_ENGINE=${XDG_BACKEND:-}
ELM_ENGINE=${XDG_BACKEND:-}
SDL_VIDEODRIVER=${XDG_BACKEND:-}
SDL_VIDEO_DRIVER=${XDG_BACKEND:-};x11
QT_QPA_PLATFORM=${XDG_BACKEND:-};xcb
QT_QPA_PLATFORMTHEME=gtk3                   #qt6ct;qt5ct;$XDG_BACKEND
GSK_RENDERER=vulkan
#QT_AUTO_SCREEN_SCALE_FACTOR=1
#QT_SCREEN_SCALE_FACTORS=1
#AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1   # MULTI-GPU PRIORITY
"
    XORG="                                  # LIST
GDK_BACKEND=x11                             # FORCE BACKEND
XDG_BACKEND=x11                             # FORCE BACKEND
"
    WAYLAND="                               # LIST
GDK_BACKEND=wayland                         # FORCE BACKEND
XDG_BACKEND=wayland                         # FORCE BACKEND
MOZ_ENABLE_WAYLAND=1                        # MOZILLA BROWSERS
QT_WAYLAND_FORCE_DPI=physical
QT_WAYLAND_DISABLE_WINDOWDECORATION=1
ELECTRON_OZONE_PLATFORM_HINT=wayland
#QT_WAYLAND_SHELL_INTEGRATION=layer-shell
#DISPLAY=$WAYLAND_DISPLAY:0                 # EXPORT FOR SPECIFIC APPS
#WAYLAND_DEBUG=1                            # EXPORT FOR DEBUGGING (1, client, server)
"
    AMD="                                   # LIST
VDPAU_DRIVER=radeonsi
LIBVA_DRIVER_NAME=radeonsi
RADV_PERFTEST=aco                           # DEFAULT MESA:V20.2
mesa_glthread=true
#AMD_VULKAN_ICD=RADV                        # AMDVLK
#DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
#MESA_LOADER_DRIVER_OVERRIDE=/lib/dri/radeonsi_dri.so
#VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
#VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_icd32.json:/usr/share/vulkan/icd.d/amd_icd64.json
"
    NVIDIA="                                # LIST
VDPAU_DRIVER=nvidia
LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
NVD_BACKEND=direct
__GLX_VENDOR_LIBRARY_NAME=nvidia
__GL_GSYNC_ALLOWED=1
__GL_VRR_ALLOWED=1
__GL_SHADER_DISK_CACHE=1
__GL_SHADER_DISK_CACHE_PATH=/tmp/shaders
#__GL_THREADED_OPTIMIZATION=1               # PER-GAME BENCHMARKS
#WLR_DRM_NO_ATOMIC=1                        # LEGACY DRM INTERFACE
"
    INTEL="                                 # LIST
INTEL=RETARD_ALERT                          # UNLESS FOR IGPU
VDPAU_DRIVER=va_gl
LIBVA_DRIVER_NAME=iHD
"

    case "$PCI_LOWER" in
        *vga*|*3d*)
            case "$PCI_LOWER" in
                *amd*|*radeon*) VENDOR="amd" ;;
                *nvidia*)       VENDOR="nvidia" ;;
                *intel*)        VENDOR="intel" ;;
            esac
        ;;
    esac

    case "${XDG_BACKEND:-}" in
        wayland) ENLISTMENT="$ENLISTMENT $WAYLAND" ;;
        x11)     ENLISTMENT="$ENLISTMENT $XORG" ;;
        "")      ;; 
        *)       printf "\n[?] UNKNOWN XDG_BACKEND: [%s]\n" "${XDG_BACKEND:-}" ;;
    esac

    case "$VENDOR" in
        amd)    ENLISTMENT="$ENLISTMENT $AMD" ;;
        nvidia) ENLISTMENT="$ENLISTMENT $NVIDIA" ;;
        intel)  ENLISTMENT="$ENLISTMENT $INTEL" ;;
    esac

    printf "\n[*] ENUMERATING PRIVILEGE ESCALATE METHODS...\n"
    if [ "$(id -u 2>/dev/null)" = "0" ]; then
        printf "[✓] FOUND: 'root'\n"
    elif command -v sudo >/dev/null 2>&1; then
        ESCALATE="sudo"
        printf "[✓] FOUND: '%s'\n" "$ESCALATE"
   elif command -v pkexec >/dev/null 2>&1; then
        ESCALATE="pkexec"
        printf "[✓] FOUND: '%s'\n" "$ESCALATE"
    else
        printf "\n[!] PRIVILEGED COMMAND NOT FOUND...\n"
        while :; do
            printf "[?] ENTER PRIVILEGED COMMAND: " 
            read -r ESCALATE
            if ${ESCALATE} true >/dev/null 2>&1; then
                printf "[✓] FOUND: %s\n" "$ESCALATE"
                break
            else
                printf "[!] INVALID COMMAND: [%s]\n" "$ESCALATE"
            fi
        done
    fi

    case "$INPUT" in
        -c*|--c*)
            printf "\n==========================================\n"
            printf "[?] CHECKING EXPORTS: [.bashrc]\n\n"
            printf "%s\n" "$ENLISTMENT"
            printf "\n──────────────────────────────────────────\n"
            printf "[?] CHECKING EXPORTS: [%s]\n\n" "$ENVFILE"
            
            ${ESCALATE:+$ESCALATE }cat "$ENVFILE"
            printf "\n==========================================\n"
        ;;
        -l*|--l*)
            _OLD_IFS="$IFS"
            IFS="
"
            printf "\n[+] EXPORTING TO: [%s(%s)]\n\n" "$UID" "$USER"
            CLEAN_LIST=$(printf '%s\n' "$ENLISTMENT" | sed -e 's/^[ 	]*//' -e 's/[ 	]*#.*//' -e '/^$/d' -e '/^\#/d')
            for CLEANED in $CLEAN_LIST; do
                printf "[✓] %s\n" "$CLEANED"
                export "${CLEANED%%=*}"="${CLEANED#*=}"
            done
            IFS="$_OLD_IFS"
        ;;
        -g*|--g*)
            CLEANED_GLOBAL=$(printf '%s\n' "$ENLISTMENT" | sed -e 's/^[  ]*//' | grep -v '^#' | grep -v '^$' | sed -e 's/[   ]*#.*//')

            printf "\n[+] EXPORTING TO: [%s]\n" "$ENVFILE"
            if [ ! -f "$ENVFILE" ]; then
                ${ESCALATE:+$ESCALATE }touch "$ENVFILE"
                ${ESCALATE:+$ESCALATE }chmod 644 "$ENVFILE"
            fi
            
            printf "[?]:[%s.bak] CREATE BACKUP? (Yes/No): " "$ENVFILE" 
            read -r CONFIRMBAK
            case "$CONFIRMBAK" in
                [Yy]*)
                    ${ESCALATE:+$ESCALATE }cp "$ENVFILE" "$ENVFILE.bak"
                    printf "[✓] BACKED-UP\n"
                ;;
                *)
                    printf "\n[!] OVERWRITING: [%s]\n" "$ENVFILE"
                    ${ESCALATE:+$ESCALATE }cat "$ENVFILE"
                    printf "\n[!] ^-FINAL_COPY-^\n"
                ;;
            esac

            printf "\n[!] #DELETING_ALL_COMMENTED_LINES\n"
            printf "[+] IMPORTING NEW HEADER\n\n"
            printf "# BASH IMPORT (%s)\n#\n# PARSED BY pam_env MODULE\n#\n# KEY=VAL\n\n%s\n" "$(date)" "$CLEANED_GLOBAL" | ${ESCALATE:+$ESCALATE }tee "$ENVFILE" >/dev/null
            printf "[✓] UPDATED:\t[%s]\n" "$ENVFILE"
        ;;
        *)
            printf "\n[ %s ]\n\n" "$0"
            printf -- "-[ H/help   ]:\tHelp Menu\n"
            printf -- "-[ C/check  ]:\tCheck Variables [.bashrc]+[%s]\n" "$ENVFILE"
            printf -- "-[ L/ ]:\texport to [%s(%s)]\n" "$UID" "$USER"
            printf -- "-[ G/global ]:\tGobal export to [%s]\n" "$ENVFILE"
        ;;
    esac
    printf "\n[✓] DONE\n\n"
}

#─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(EXECUTABLES)───
startups() {
    INPUT=$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')
    WRAPPER="" 
    DESKTOP="$HOME/.config/autostart/COMMANDS.desktop"
    APPS="
dbus-update-activation-environment --systemd --all
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
#gnome-keyring-daemon --start --components=secrets
exporter --local
backup
noctalia
xdg-autostart
#wlsunset -s 22:00 -S 10:00 -d 60
wl-paste --type text --watch cliphist store
wl-paste --type image --watch cliphist store
#───(GSETTINGS
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface font-name 'Sony Sketch EF'
#───(MINIMIZE_FLAGS
#emacs --daemon
#openrgb --startminimized wayland
#steam-native -silent wayland
#vesktop --start-minimized wayland
#telegram-desktop -startintray wayland
#youtube-music --use-tray-icon wayland
#teams --startminimized wayland
"

    if command -v uwsm >/dev/null 2>&1; then
        WRAPPER="uwsm-app --"
    elif command -v systemd-run >/dev/null 2>&1; then
        WRAPPER="systemd-run --user --scope"
    fi

    case "$INPUT" in
        -l*|--l*)
            printf '%s\n' "$APPS" | while IFS= read -r APP; do
                # Strip leading/trailing spaces and skip comments or empty lines
                APP=$(printf '%s' "$APP" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                { [ -z "$APP" ] || [ "${APP#\#}" != "$APP" ]; } && continue

                NAME=$(printf '%s' "$APP" | cut -d' ' -f1)
                printf "[✓] LAUNCHING: %s\n" "$APP"

                if [ -n "$WRAPPER" ]; then
                    nohup $WRAPPER $APP >/dev/null 2>&1 &
                else
                    nohup $APP >/dev/null 2>&1 &
                fi
                sleep 0.1
                
                printf "────────────────────────────\n"
                if ps -e -o pid,args 2>/dev/null | grep -v "startups" | grep -q "^[ ]*[0-9]*[ ]*$NAME"; then
                    printf "────────────────────────────\n\n"
                else
                    printf "[X] May have failed: %s\n\n" "$NAME"
                fi
            done
        ;;
        -k*|--k*)
            printf '%s\n' "$APPS" | while IFS= read -r APP; do
                APP=$(printf '%s' "$APP" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                { [ -z "$APP" ] || [ "${APP#\#}" != "$APP" ]; } && continue
                
                NAME=$(printf '%s' "$APP" | cut -d' ' -f1)
                printf "[✓] TERMINATING: %s\n────────────────────────────\n" "$APP"
                TARGET_PIDS=$(ps -e -o pid,args | grep "^[ ]*[0-9]*[ ]*$NAME" | awk '{print $1}')
                if [ -n "$TARGET_PIDS" ]; then
                    kill $TARGET_PIDS 2>/dev/null || kill -9 $TARGET_PIDS 2>/dev/null
                fi
                printf "────────────────────────────\n\n"
            done
        ;;
        -e*|--e*)
            printf "\n[+] GENERATING SINGLE-LINE EXEC AUTOSTART: [%s]\n" "$DESKTOP"

            DESKTOP_DIR=$(dirname "$DESKTOP")
            mkdir -p "$DESKTOP_DIR" && rm -f "$DESKTOP"

            # Parse $APPS to exclude xdg-autostart, empty lines, and comments, then chain them
            EXEC_CHAIN=$(printf '%s\n' "$APPS" | grep -v "xdg-autostart" | grep -v '^[[:space:]]*#' | grep -v '^[[:space:]]*$' | awk '{printf "%s & ", $0}' | sed 's/ & $/ \&/')
            EXEC_CHAIN_ESC=$(printf '%s' "$EXEC_CHAIN" | sed 's/"/\\"/g')

            printf "[Desktop Entry]\nName=COMMANDS\nIcon=Terminal\nType=Application\nTerminal=false\nComment=POSIX Generated\nHidden=false\nExec=sh -c \"%s\"\n" \
                "$EXEC_CHAIN_ESC" > "$DESKTOP"

            chmod +x "$DESKTOP"
            startups -c
        ;;
        -c*|--c*)
            if [ "${XDG_SESSION_DESKTOP:-}" = "TTY" ]; then
                printf "\nSAFE_TO_EXECUTE_SCRIPT\nUSECASE:\t<ORGANIZED_SHELL_COMMANDS>\n\n"
            else
                if [ -n "${XDG_SESSION_DESKTOP:-}" ]; then
                    printf "\nEXPORT_ONCE_AND_FORGET\n\n"
                fi
            fi
            printf "────────────────────────────\n"
            if [ -f "$DESKTOP" ]; then
                while IFS= read -r LINE; do printf "%s\n" "$LINE"; done < "$DESKTOP"
            else
                printf "[?] MISSING: %s\n" "$DESKTOP"
            fi
            printf "────────────────────────────\n\n"
        ;;
        *)
            printf -- "-[ H/help     ]: Help Menu\n-[ L/launch   ]: Re/Launch APPS\n-[ K/kill     ]: Kill All APPS\n-[ E/export   ]: Export/Delete [%s]\n-[ C/check    ]: Output [%s]\n\n" "$DESKTOP" "$DESKTOP"
        ;;
    esac
}

#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(AUTOMATE_PACKAGES_BACKUPS)───
backup() {
    PACKAGED=$(find "$HOME" -type f -name PACKAGES 2>/dev/null | head -n 1)
    : "${PACKAGED:=$HOME/.config/PACKAGES}"
    PM=""

    for WRAPPER in apk apt brew dnf pacman qlist xbps-query zypper; do
        command -v "$WRAPPER" >/dev/null 2>&1 && PM="$WRAPPER" && break
    done

    printf "#---(UPDATED: %s | PM: %s)\n" "$(date)" "${PM:-unknown}" > "$PACKAGED"

    case "$PM" in
        apk)        apk info ;;
        apt)        apt-mark showmanual ;;
        brew)       brew leaves ;;
        dnf)        dnf repoquery --installed --queryformat '%{name}\n' ;;
        pacman)     pacman -Qqe ;;
        qlist)      qlist -I ;;
        xbps-query) xbps-query -l | awk '{print $2}' ;;
        zypper)     zypper --quiet packages --installed-only | awk -F '|' 'NR>4 {print $3}' | tr -d ' ' ;;
        *)          printf "\n-- UNKNOWN_PACKAGE_MANAGER --\n" ;;
    esac >> "$PACKAGED"

    printf "Backup Complete -> %s\n" "$PACKAGED"
}

#──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(AUTOMATE_PACKAGES_INSTALLATION)───
installation() {
    LINE="" PM="" CMD="" PACKAGES="" USER_INPUT=""

    INPUT=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
    DISTRO="Unknown Linux"
    ID="unknown"
    PACKAGED=$(find "$HOME" -type f -name PACKAGES 2>/dev/null | head -n 1)
    : "${PACKAGED:=$HOME/.config/PACKAGES}"
    URL="https://raw.githubusercontent.com/F7YYY/dotfiles/master/.config/PACKAGES"

    if [ -f /etc/os-release ]; then
        while IFS= read -r LINE; do
            case "$LINE" in
                PRETTY_NAME=*)
                    DISTRO=${LINE#*=}
                    DISTRO=$(printf '%s' "$DISTRO" | tr -d '"')
                    ;;
                ID=*)
                    ID=${LINE#*=}
                    ID=$(printf '%s' "$ID" | tr -d '"')
                    ;;
            esac
        done < /etc/os-release
    fi

    cd "$HOME" || return 1

    printf '%s\n' "
##############################
 \`\`***%%@@@_ _
          ( Y )
           \ /
            V
    ________H_  ,%%&%,
   /\     _   \ %%&&%%&%
  /  \___/^\___\&%%&%%&&
  |  |[I]   [I]| %%YY&%'
  |  |   .-.   |  ||
~~%%._!@@_|-|_@@!~~||
~~~~~~~~~)=)~~~~~~~~
😁 Welcoming Improved Commits!
##############################
Home:         $(pwd)
Distribution: $DISTRO
Architecture: $ID
Packaged:     $PACKAGED
##############################
"

    if [ ! -f "$PACKAGED" ]; then
        printf "Downloading latest PACKAGES...\n"
        mkdir -p "$(dirname "$PACKAGED")"
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$URL" -o "$PACKAGED"
        elif command -v wget >/dev/null 2>&1; then
            wget -q "$URL" -O "$PACKAGED"
        else
            if command -v notify-send >/dev/null 2>&1; then
                notify-send -u critical -a "ERROR" "CURL/WGET NOT FOUND!"
            fi
            printf "Error: curl or wget required.\n"
            INPUT="-h"
        fi
    fi

    case "$INPUT" in
        ""|*h*)
            printf '\n-[ I/install ]: Run Installer\n-[ R/retry  ]: Rerun Script\n-[ C/create ]: Create/Edit list\n-[ Q/quit   ]: Exit\n\n?: '
            read -r USER_INPUT
            installation "$USER_INPUT"
            return 0
            ;;
        *r*)
            printf "\nRetrying...\n"
            installation ""
            return 0
            ;;
        *c*)
            mkdir -p "$(dirname "$PACKAGED")"
            [ ! -f "$PACKAGED" ] && printf "# One package per line\n" > "$PACKAGED"
            printf '\n-[ E/edit ]\n-[ Q/quit ]\n\n?: '
            read -r USER_INPUT
            USER_INPUT=$(printf '%s' "$USER_INPUT" | tr '[:upper:]' '[:lower:]')
            
            if [ "$USER_INPUT" = "e" ] || [ -z "$USER_INPUT" ]; then
                CMD="${EDITOR:-nvim}"
                if command -v "$CMD" >/dev/null 2>&1; then
                    "$CMD" "$PACKAGED"
                elif command -v vi >/dev/null 2>&1; then
                    vi "$PACKAGED"
                else
                    printf "No editor found. Append packages manually to: %s\n" "$PACKAGED"
                fi
            fi
            return 0
            ;;
        *q*)
            printf "\nExiting...\n"
            return 0
            ;;
        *i*)
            printf "\nParsing package list...\n"
            ;;
    esac

    if [ ! -f "$PACKAGED" ] || [ ! -s "$PACKAGED" ]; then
        printf "Error: Package list is empty or missing.\n"
        return 1
    fi

    PACKAGES=""
    while IFS= read -r LINE; do
        LINE=$(printf '%s' "$LINE" | cut -d'#' -f1 | tr -d '[:space:]')
        if [ -n "$LINE" ]; then
            PACKAGES="$PACKAGES $LINE"
        fi
    done < "$PACKAGED"

    PM=""
    for WRAPPER in pacman apt dnf zypper brew apk xbps-query qlist; do
        command -v "$WRAPPER" >/dev/null 2>&1 && PM="$WRAPPER" && break
    done

    printf "Deploying packages via native manager [%s]...\n" "${PM:-unknown}"

    case "$PM" in
        apk)        sudo apk update && sudo apk add $PACKAGES ;;
        apt)        sudo apt-get update && sudo apt-get install -y $PACKAGES ;;
        brew)       brew install $PACKAGES ;;
        dnf)        sudo dnf install -y $PACKAGES ;;
        pacman)     sudo pacman -Syu --needed --noconfirm $PACKAGES ;;
        xbps-query) sudo xbps-install -Sy $PACKAGES ;;
        qlist)      sudo emerge --ask=n $PACKAGES ;;
        zypper)     sudo zypper install -y $PACKAGES ;;
        *)          printf "\n-- UKNOWN_PACKAGE_MANAGER --\n" && return 1 ;;
    esac

    printf "\n[%s]: - INSTALLATION_COMPLETE\n" "$DISTRO"
}
