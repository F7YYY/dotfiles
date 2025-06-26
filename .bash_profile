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
#─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(SOURCES-BAK)───
#───(AUTO_RUN_INTERACTIVELY)
#[[ $- != *i* ]] && return      # SOURCED .BASHRC
#───(SOURCERER)
#[[ -f "$HOME/.bash_bashrc" ]] && source "$HOME/.bash_profile"
#───(SOURCE_DEFINITIONS)
#[[ -f /etc/bash.bashrc ]] && source /etc/bash.bashrc
#───(bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)")────#
#[[ -f /usr/share/oh-my-bash/oh-my-bash.sh ]] && source /usr/share/oh-my-bash/oh-my-bash.sh      # BROKEN-PACKAGE AUR:OH-MY-BASH-GIT
#───(ENABLE_BASH_COMPLETIONS)
#[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(THEME)───
#───(GSETTINGS)
# gsettings set org.gnome.desktop.interface <KEY> <VALUE>
gsettings set org.gnome.desktop.interface clock-format 24h

#─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(ALIASES)───
alias c='clear'
alias l='ls -l --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -lahs --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ftext='clear && grep -niHIr --color=always "$1" "${2:-.}" | less -r'
alias curl='curl --user-agent "noleak"'
alias wget='wget -c --user-agent "noleak"'
alias rsync='rsync --recursive --progress'
alias logs='sudo find /var/log -type f -exec file {} + | grep "text" | cut -d " " -f1 | sed -e"s/:$//g" | grep -v "[0-9]$" | xargs tail -f'
alias alert='notify-send -u critical -a "$([ $? = 0 ] && echo TERMINAL || echo ERROR)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')" "Finished"'
alias free='free -h'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias df='df -h'
alias du='du -h'
alias dd='dd status=progress'
alias shred='shred -zf'
alias wayland='--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto'

#───(CHANGE_DIRECTORY)
alias home='cd ~ || cd "$HOME"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
#───(ARCHIVE)
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

#────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(EXPORT_ENVIRONMENT_VARIABLES)───
exporter() {
    local INPUT="${1:-}"
    local ESCALATE=""
    local ENVFILE="/etc/environment"
    local VENDOR=($(lspci | grep -iE 'vga' | grep -ioE 'amd|nvidia|intel' | awk '{print tolower($0)}'))

    #───(VARIABLES)
    local ENLISTMENT=(
        "HISTSIZE=1000"
        "HISTFILESIZE=1000"
        "HISTCONTROL=erasedups:ignoredups:ignorespace"
        "EDITOR=vscodium-electron -w"
        "GPG_TTY=$(tty)"
        "_JAVA_AWT_WM_NONREPARENTING=1"
	    "XDG_SESSION_TYPE=$XDG_BACKEND"
		#"XDG_SESSION_DESKTOP=$XDG_CURRENT_DESKTOP" # EXPORT IF NOT DEFAULTING TO DE/WM
		#"XDG_CURRENT_DESKTOP=$XDG_SESSION_DESKTOP" # EXPORT IF NOT DEFAULTING TO DE/WM
        "CLUTTER_BACKEND=$XDG_BACKEND"
        "ECORE_EVAS_ENGINE=$XDG_BACKEND"
        "ELM_ENGINE=$XDG_BACKEND"
        "SDL_VIDEODRIVER=$XDG_BACKEND"
        "SDL_VIDEO_DRIVER=$XDG_BACKEND"             # ONLY SET PER-STUTTERING STEAM GAME | STEAM WON'T LAUNCH
        "QT_QPA_PLATFORM=$XDG_BACKEND;xcb"
        "QT_QPA_PLATFORMTHEME=qt6ct;qt5ct"          #$XDG_BACKEND"
        "QT_AUTO_SCREEN_SCALE_FACTOR=1"
        #"QT_SCREEN_SCALE_FACTORS=1;1"               # FLAMESHOT
	    #"AQ_DRM_DEVICES,'/dev/dri/card0:/dev/dri/card1'"   # MULTI-GPU PRIORITY
    )
    local XORG=(
		"GDK_BACKEND=x11"                           # FORCE BACKEND
		"XDG_BACKEND=x11"                           # FORCE BACKEND
	)
    local WAYLAND=(
		"GDK_BACKEND=wayland"						# FORCE BACKEND
		"XDG_BACKEND=wayland"						# FORCE BACKEND
		"MOZ_ENABLE_WAYLAND=1"						# MOZILLA BROWSERS
		"QT_WAYLAND_FORCE_DPI=physical"
		"QT_WAYLAND_DISABLE_WINDOWDECORATION=1"
		#"QT_WAYLAND_SHELL_INTEGRATION=layer-shell"
		#"DISPLAY=$WAYLAND_DISPLAY:0"			    # EXPORT FOR SPECIFIC APPS
	    #"WAYLAND_DEBUG=1"				            # EXPORT FOR DEBUGGING (1, client, server)
	)
    local AMD=(
		#"VDPAU_DRIVER=radeonsi"
		#"LIBVA_DRIVER_NAME=radeonsi"
        #"RADV_PERFTEST=aco"						# DEFAULT MESA:V20.2
        #"mesa_glthread=true"
        #"AMD_VULKAN_ICD=RADV"						# AMDVLK
        #"DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1"
        #"MESA_LOADER_DRIVER_OVERRIDE=/lib/dri/radeonsi_dri.so"
        #"VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json"
        #"VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_icd32.json:/usr/share/vulkan/icd.d/amd_icd64.json"
	)
    local NVIDIA=(
		"VDPAU_DRIVER=nvidia"
		"LIBVA_DRIVER_NAME=nvidia"
		"GBM_BACKEND=nvidia-drm"
		"LIBVA_DRIVER_NAME=nvidia"
		"__GLX_VENDOR_LIBRARY_NAME=nvidia"
		"__GL_GSYNC_ALLOWED"
		"__GL_VRR_ALLOWED"
		"__GL_SHADER_DISK_CACHE=1"
		"__GL_SHADER_DISK_CACHE_PATH=/tmp/shaders"
        #"__GL_THREADED_OPTIMIZATION=1"             # PER-GAME BENCHMARKS
		#"WLR_DRM_NO_ATOMIC=1"				        # LEGACY DRM INTERFACE
	)
    local INTEL=(
		"INTEL=RETARD_ALERT"						# UNLESS FOR IGPU
		"VDPAU_DRIVER=va_gl"
		"LIBVA_DRIVER_NAME=iHD"
	)
    
    #───(BACKEND_APPEND)
    case "$XDG_BACKEND" in
        wayland) ENLISTMENT+=$WAYLAND ;;
        x11) ENLISTMENT+=$XORG ;;
        *) echo -e "\n[?] UNKNOWN XDG_BACKEND: [$XDG_BACKEND]" ;;
    esac

    #───(GPU_APPEND)
    for GPU in "${VENDOR[@]}"; do
        case "$GPU" in
            amd) ENLISTMENT+=$AMD ;;
            nvidia) ENLISTMENT+=$NVIDIA ;;
            intel) ENLISTMENT+=$INTEL ;;
            *) echo -e "\n[?] UNKNOWN GPU: [$GPU]" ;;
        esac
    done

    #───(PRIVILEGE_DETECTION)
    echo -e "\n[*] ENUMERATING PRIVILEGE ESCALATE METHODS..."
    if [[ $EUID -eq 0 ]]; then
        echo -e "[✓] FOUND: 'root'"
    elif command -v sudo &>/dev/null; then
        ESCALATE="sudo"
        echo -e "[✓] FOUND: '$ESCALATE'"
    elif command -v pkexec &>/dev/null; then                        # BYPASSES ROOT ESCALATION
        ESCALATE="pkexec"
        echo -e "[✓] FOUND: '$ESCALATE'"
    else
        echo -e "\n[!] PRIVILEGED COMMAND NOT FOUND..."
        while true; do
            read -rp "[?] ENTER PRIVILEGED COMMAND: " ESCALATE
            if [ $ESCALATE cat $ENVFILE &>/dev/null ]; then
                echo -e "[✓] FOUND: $ESCALATE"; break
            else
                echo -e "[!] INVALID COMMAND: [$ESCALATE]"
            fi
        done
    fi

    #───(INTERACTION LOGIC)
    case "$INPUT" in
        -[Hh]*|--[Hh]*|"")
            echo -e "\n[ $0 ]\n"
			echo -e "-[ H/help   ]:\tHelp Menu"
            echo -e "-[ C/check  ]:\tCheck Variables [.bashrc]+[$ENVFILE]"
            echo -e "-[ L/local  ]:\tLocal export to [$UID($USER)]"
            echo -e "-[ G/global ]:\tGobal export to [$ENVFILE]"
        ;;
        -[Cc]*|--[Cc]*)
            echo -e "\n==========================================\n"
            echo -e "[?] CHECKING EXPORTS: [.bashrc]\n"
            for VAR in "${ENLISTMENT[@]}"; do echo -e "$VAR"; done
            echo -e "\n──────────────────────────────────────────\n"
            echo -e "[?] CHECKING EXPORTS: [$ENVFILE]\n"
            $ESCALATE cat "$ENVFILE"
            echo -e "\n==========================================\n"
        ;;
        -[Ll]*|--[Ll]*)
            echo -e "\n[+] EXPORTING TO: [$UID($USER)]\n"
            for VAR in "${ENLISTMENT[@]}"; do
                echo -e "[✓] EXPORTED: "$VAR""
		        export "$VAR"
	        done
        ;;
        -[Gg]*|--[Gg]*)
            echo -e "\n[+] EXPORTING TO: [$ENVFILE]"

            # Ensure $ENVFILE exists with correct perms
            [[ ! -f $ENVFILE ]] && $ESCALATE touch "$ENVFILE" && $ESCALATE chmod 644 "$ENVFILE"

            echo -e "[?]: CREATE BACKUP: [$ENVFILE.bak]"
            read -rp "BACKUP? (Yes/No): " CONFIRMBAK
            if [[ "$CONFIRMBAK" =~ ^[Yy] ]]; then
                $ESCALATE cp "$ENVFILE" "$ENVFILE.bak"
                echo -e "[✓] BACKED-UP"
            else
                echo -e "\n[!] OVERWRITING: [$ENVFILE]"
                $ESCALATE cat "$ENVFILE"
                echo -e "\n[!] ^-FINAL_COPY-^\n"
            fi

            # Replace old header block with new one
            echo -e "\n[!] #DELETING_ALL_COMMENTED_LINES\n[+] IMPORTING NEW HEADER\n"
            $ESCALATE sed -i '/^#' "$ENVFILE"
            local HEADER="# .BASHRC IMPORT ($(date))\n#\n# PARSED BY pam_env MODULE\n#\n# KEY=VAL\n"
            $ESCALATE sed -i -E '/^\s*#/d' "$ENVFILE"           # MUST STAY SEPERATED
            $ESCALATE sed -i -E "1s|^|$HEADER|" "$ENVFILE"      # MUST STAY SEPERATED

            # Recursively iterate though all lines and arrays for changes
            for VAR in "${ENLISTMENT[@]}"; do
                local KEY="${VAR%%=*}"
                local VAL="${VAR#*=}"
                local LINE=$($ESCALATE grep -E "^\s*${KEY}=" "$ENVFILE")

                if [ grep  "$KEY" == "$VAR" ]; then
                    echo -e "[FOUND]:\t$LINE"
                    echo -e "[REPLACEMENT]:\t$VAR"
                    read -rp "REPLACE? (Yes/No): " CONFIRMREP
                    if [[ "$CONFIRMREP" =~ ^[Yy] ]]; then
                        $ESCALATE sed -i "s|^\s*${KEY}=.*|${VAR}|" "$ENVFILE"
                        echo -e "[✓] REPLACED: $VAR"
                    elif [[ "$LINE" == "$VAR" ]]; then
                        echo -e "[-] SKIPPED: $VAR"
                        continue
                    fi
                else
                    # Delete commented versions
                    $ESCALATE sed -i "/^#\s*${KEY}=.*/d" "$ENVFILE"
                    echo -e "[+] ADDING:\t$VAR"
                    echo "$VAR" | $ESCALATE tee -a "$ENVFILE" > /dev/null
                fi
            done

            # Final copy into /etc/environment
            echo -e "\n[✓] UPDATED:\t[$ENVFILE]"
        ;;
        *)
            echo -e "\n[!] UNKNOWN INPUT: $1\n"
            exporter -h
        ;;
    esac
    echo -e "\n[✓] DONE\n"
}

#─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(EXECUTABLES)───
startups() {
    local INPUT="$@"
    local LAUNCH=""
    local UWSM=0
    local DESKTOP="$HOME/.config/autostart/COMMANDS.desktop"
    local APPLICATIONS=(
        #"dbus-update-activation-environment --systemd --all"   # MANAGED BY AUR:UWSM
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
        "'gnome-keyring-daemon --start --components=secrets'"
        "'exporter --LOCAL'"
        "backup"
        "waybar"
        #"waypaper --restore"
        #"xdg-autostart"						# AUR:UWSM MANAGED
        #"wlsunset -s 22:00 -S 10:00 -d 60"
        #"wl-paste --type text --watch cliphist store"
        #"wl-paste --type image --watch cliphist store"
        #───(MINIMIZED_FLAGS)
        #"emacs --daemon"
        #"openrgb --startminimized wayland"
        #"steam -silent wayland"
        #"vesktop --start-minimized wayland"
        #"telegram-desktop -startintray wayland"
        #"youtube-music --use-tray-icon wayland"
        #"teams --startminimized wayland"
    )

    [ command -v uwsm &>/dev/null ] && UWSM=1 || UWSM=0

    #───(MANAGE_EXECUTIONS)
    case $INPUT in
        ""|-[Hh]*|--[Hh]*)
            echo -e "\n[ $0 ]\n"
    	    echo -e "-[ H/help     ]: Help Menu"
    	    echo -e "-[ L/launch   ]: Re/Launch Apps"
    	    echo -e "-[ K/kill     ]: Kill All Apps"
            echo -e "-[ E/export   ]: Export All to [$DESKTOP]"
            echo -e "-[ C/check    ]: Output [$DESKTOP]\n"            
        ;;
        -[Ll]*|--[Ll]*)
            $0 --kill

            for APP in "${APPLICATIONS[@]}"; do
                local NAME="${APP%% *}"

                echo -e "[✓] LAUNCHING: "$APP""
                [ $UWSM -eq 1 ] && LAUNCH="uwsm-app" || LAUNCH="eval"
                $LAUNCH "$APP" &>/dev/null &disown
                if pgrep -af "$NAME" &>/dev/null; then
                    echo -e "────────────────────────────"
                    pgrep -af "$NAME" 
                    echo -e "────────────────────────────\n"
                fi
            done
        ;;
        -[Kk]*|--[Kk]*)
            for APP in "${APPLICATIONS[@]}"; do
                local NAME="${APP%% *}"

                echo -e "[✓] TERMINATING: "$APP""
                if pgrep -af "$NAME" &>/dev/null; then
                    echo -e "────────────────────────────"
                    pkill -9 -f -e "$NAME"
                    pkill -9 -f -e "$APP"
                    echo -e "────────────────────────────\n"
                else
                    pkill -9 "$NAME" &>/dev/null
                    pkill -9 "$APP" &>/dev/null
                fi
            done
        ;;
        -[Ee]*|--[Ee]*)
            local ENTRY="[Desktop Entry]\nName=COMMANDS\nIcon=Terminal\nType=Application\nEncoding=UTF-8\nTerminal=true\nStartupNotify=true\nComment='.bash_profile generated $0'\n"

            # Ensure $DESKTOP is configured
            if [[ ! -f "$DESKTOP" || ! -s "$DESKTOP" ]]; then
                echo -e "$ENTRY" > "$DESKTOP"
                chmod +x "$DESKTOP"
                echo -e "[+] CREATED:\t$DESKTOP"
            else
                echo -e "\n[+] REFORMATTING: [$DESKTOP]"
                # Replace all none Exec= lines
                sed -i -E '/^\s*Exec=/!d' "$DESKTOP"        # MUST STAY SEPERATED
                sed -i -E "1s|^|$ENTRY|" "$DESKTOP"         # MUST STAY SEPERATED
                # Report removed lines if any were found
                local REMOVED_LINES=$(grep -v '^\s*Exec=' "$DESKTOP")
                if [[ -n "$REMOVED_LINES" ]]; then
                    echo -e "[-] REMOVED_LINES:\n$REMOVED_LINES\n────────────────────────────"
                fi
            fi

            # Add or replace applications from the APPLICATIONS array
            for APP in "${APPLICATIONS[@]}"; do
                local LINE="Exec=$APP"
                local FOUND=$(grep -E "^\s*Exec\s*=\s*${APP}" "$DESKTOP")

                if [[ -n "$FOUND" && "$FOUND" != "$LINE" ]]; then
                    echo -e "\n[>] FOUND:\t$FOUND"
                    echo -e "[<] REPLACE:\t$LINE"
                    read -rp "[y/N] REPLACE?: " CONFIRMREP
                    if [[ "$CONFIRMREP" =~ ^[Yy] ]]; then
                        sed -i -E "s|^\s*${FOUND}|$LINE|" "$DESKTOP"
                        echo -e "[✓] REPLACED:\t$APP"
                    else
                        echo -e "[-] SKIPPED:\t$APP"
                    fi
                elif [[ -n "$FOUND" && "$FOUND" == "$LINE" ]]; then
                    echo -e "[-] SKIPPED:\t$APP"
                else
                    echo "$LINE" >> "$DESKTOP"
                    echo -e "[+] ADDED:\t$APP"
                fi
            done

            $0 --check
        ;;
        -[Cc]*|--[Cc]*)
            #───(PEACE_OF_MIND)
            #   if [ $XDG_SESSION_DESKTOP = "TTY" ]; then
            #       echo -e "\nSAFE_TO_EXECUTE_SCRIPT";
            #       echo -e "\nUSECASE:\t<ORGAINZED_SHELL_COMMANDS>\n"
            #   elif [ -f "$DESKTOP" ]
            #       echo "EXPORT_ONCE_AND_FORGET" > "$DESKTOP"
            #   else
            #       echo -e "\nUSE_AS_NEEDED\n"
            #   fi
            echo -e "\n────────────────────────────"
            cat "$DESKTOP" 
            echo -e "────────────────────────────\n"
        ;;
        *)
            echo -e "\n[?] UNKNOWN_INPUT: $1\n"
            $0 --help
        ;;
    esac
}

#──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(AUTOMATE_PACKAGES_INSTALLATION)───
install_packages() {
	local INPUT="$1"
	local DISTRO="$(grep -w "^PRETTY_NAME" /etc/os-release | cut -d '"' -f 2)"	# SIMPLY-(lsb_release -sd)
	local ID="$(grep -w "^ID" /etc/os-release | cut -d '=' -f 2)"
	local PACKAGED="$(find . -type f -name PACKAGES)"
	local URL=(https://raw.githubusercontent.com/F7YYY/dotfiles/master/.config/PACKAGES)

	cd $HOME || ~
	echo -e "
##############################
 ``***%%@@@_ _
          ( Y )
           \ /
            V
    ________H_  ,%%&%,
   /\     _   \ %&&%%&%
  /  \___/^\___\&%&%%&&
  |  |[I]   [I]| %YY&%'
  |  |   .-.   |  ||
~~%._!@@_|-|_@@!~~||
~~~~~~~~~)=)~~~~~~~~
😁 Welcoming Improved Commits!
##############################
Home:\t\t$(pwd)
Distribution:\t$DISTRO
Architecture:\t$ID
Packaged:\t$PACKAGED
##############################
"
	if [ ! -f "$PACKAGED" &>/dev/null ]; then
		echo -e "Downloading the latest [$URL] -> [$(pwd)]"
		if whereis curl &>/dev/null; then
			whereis curl
			curl $URL -o PACKAGES

		elif whereis wget &>/dev/null; then
			whereis wget
			wget $URL
		else
			whereis curl wget
			notify-send -u critical -a "ERROR" "CURL & WGET NOT FOUND - Manual Download/Creation Required!"
			echo -e "\n- CURL & WGET NOT FOUND!\n- Manual Download/Creation Required!\n"
			install_packages -h
		fi
	elif [ -f "$PACKAGED" &>/dev/null ]; then
		echo -e "Obtained the latest PACKAGES"
		echo -e "Path: [$PACKAGED]\n"
		echo -e "##############################\n"
	else
		return 1 && echo -e "\n_WTF_\n"
	fi

	case $INPUT in
		""|-[Hh]*|--[Hh]*)
            echo -e "\n[ $0 ]\n"
			echo -e "-[ H/help   ]:\tHelp Menu"
			echo -e "-[ R/retry  ]:\tRerun Script"
			echo -e "-[ C/create ]:\tCreate personalized "PACKAGES" list"
			echo -e "-[ Q/quit   ]:\tExit Script\n"
			read -p "?: " INPUT
			install_packages "$INPUT"
		;;
		-[Rr]*|--[Rr]*)
			echo -e "\nRETRYING_SCRIPT\n"
			return 1 && install_packages
		;;
		-[Cc]*|--[Cc]*)
			echo -e "#─LIST_ONE_PACKAGE_PER-LINE\n" > $HOME/.config/PACKAGES
			echo -e "\n[$PACKAGED]\n"
			echo -e "-[ E/edit ]:\t'${EDITOR}'"
			echo -e "-[ Q/quit ]:\tExit & Manually Edit\n"
			read -p "?: " INPUT
			case $INPUT in
				""|-[Ee]*|--[Ee]*)
					if whereis "$EDITOR" &>/dev/null; then
						$EDITOR $PACKAGED
					elif whereis nvim &>/dev/null; then
						nvim $PACKAGED
					elif whereis vim &>/dev/null; then
						vim $PACKAGED
					else
						echo -e "\n- Editor not exported"
						echo -e "- NeoVim & Vim not available"
						echo -e "> Manual editing required after listing [$PACKAGED] <"
						echo -e "##############################\n"
						read -p "List_Packages: " LIST
						tr ' ' '\n' <<< "$LIST" >> "$PACKAGED"
					fi
				;;
				-[Qq]*|--[Qq]*)
					return 1 && echo -e "\nExiting_Script\n\n##############################"
				;;
				*)
                    echo -e "\n[!] UNKNOWN INPUT: $1\n"
                    install_packages -h
				;;
			esac
		;;
		-[Qq]*|--[Qq]*)
			return 1 && echo -e "\nExiting_Script\n\n##############################"
		;;
		*)
            echo -e "\n[!] UNKNOWN INPUT: $1\n"
            install_packages -h
		;;
	esac

	case $ID in
		#===(COPY_BETWEEN)=================================================================
		arch)
			# BETTER PACKAGE MANAGER INSTALLATION
    		if ! whereis yay &>/dev/null; then
    		    sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
    		    cd $HOME && find . -type d -name "yay-bin" -exec rm -fr "{}" +
    		    echo -e "[$DISTRO] Package Manager Installed: YAY!" 2>&1
				yay -Siq yay-bin
    		fi
			# "PACKAGES" INSTALLATION
			if whereis yay &>/dev/null; then
    		    yay -Syyu --needed - < $PACKAGED && sudo pacman-fix-permissions && yay -Ycc && yay -Sc --noconfirm
    		    notify-send -u low -a "PACKAGES" "[$DISTRO]: Updated & Packaged!"
    		    echo -e "[$DISTRO]: Updated & Packaged!" 2>&1
    		fi
		;;
		#===(MODIFY_FOR_YOUR_DISTRIBUTION)=================================================
		#	<PASTE_HERE>
		#===(COPY_BETWEEN)=================================================================
		*)
			notify-send -u critical -a "ERROR" "[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!"
    	    echo -e "[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!\n" 2>&1
    	    return 1
		;;
	esac
}

#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(AUTOMATE_PACKAGES_BACKUPS)───
backup() {
	local PACKAGED="$(find . -type f -name PACKAGES)"
	local DAY="1"												# DAY OF THE WEEK

	if [ -f "$PACKAGED" ] && [ "$(date +%u)" = "$DAY" ]; then
		echo -e "#───(UPDATED: $(date))" > "$PACKAGED"
		if whereis yay &>/dev/null; then
			yay -Qqe >> "$PACKAGED"
		elif whereis pacman &>/dev/null; then
			pacman -Qqe >> "$PACKAGED"
		else
			echo -e "\nI uSe ArCh BtW!\n"
		fi
	fi

	if [ "$(date +%u)" = "$DAY" ]; then
		git dotfiles cam "AUTO-BACKUP"
		git gui dotfiles psom
	fi
}

#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────(compdef libredefender)───
_libredefender() {
    local i cur prev opts cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}; do
        case "${cmd},${i}" in
            ",$1")
                cmd="libredefender"
            ;;
            libredefender,completions)
                cmd="libredefender__completions"
            ;;
            libredefender,dump-config)
                cmd="libredefender__dump__config"
            ;;
            libredefender,help)
                cmd="libredefender__help"
            ;;
            libredefender,infections)
                cmd="libredefender__infections"
            ;;
            libredefender,scan)
                cmd="libredefender__scan"
            ;;
            libredefender,scheduler)
                cmd="libredefender__scheduler"
            ;;
            libredefender,test-notify)
                cmd="libredefender__test__notify"
            ;;
            libredefender__help,completions)
                cmd="libredefender__help__completions"
            ;;
            libredefender__help,dump-config)
                cmd="libredefender__help__dump__config"
            ;;
            libredefender__help,help)
                cmd="libredefender__help__help"
            ;;
            libredefender__help,infections)
                cmd="libredefender__help__infections"
            ;;
            libredefender__help,scan)
                cmd="libredefender__help__scan"
            ;;
            libredefender__help,scheduler)
                cmd="libredefender__help__scheduler"
            ;;
            libredefender__help,test-notify)
                cmd="libredefender__help__test__notify"
            ;;
            *)
            ;;
        esac
    done

    case "${cmd}" in
        libredefender)
            opts="-q -v -C -D -h --quiet --verbose --colors --data --help scan scheduler infections test-notify dump-config completions help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --data)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -D)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__completions)
            opts="-q -v -C -D -h --quiet --verbose --colors --data --help bash elvish fish powershell zsh"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --data)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -D)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__dump__config)
            opts="-q -v -C -D -h --quiet --verbose --colors --data --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --data)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -D)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help)
            opts="scan scheduler infections test-notify dump-config completions help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help__completions)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help__dump__config)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help__help)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help__infections)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
            ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help__scan)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help__scheduler)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__help__test__notify)
            opts=""
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__infections)
            opts="-d -q -v -C -D -h --delete --delete-all --quiet --verbose --colors --data --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --data)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -D)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__scan)
            opts="-j -q -v -C -D -h --concurrency --quiet --verbose --colors --data --help [PATHS]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --concurrency)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -j)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                --data)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -D)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__scheduler)
            opts="-q -v -C -D -h --quiet --verbose --colors --data --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --data)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -D)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
        libredefender__test__notify)
            opts="-q -v -C -D -h --quiet --verbose --colors --data --help"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --data)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                -D)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                ;;
                *)
                    COMPREPLY=()
                ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
        ;;
    esac
}
#complete -F _libredefender -o nosort -o bashdefault -o default libredefender       # NOT_ZSH_FRIENDLY
alias defender="complete -F _libredefender -o nosort -o bashdefault -o default libredefender"
