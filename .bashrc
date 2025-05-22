#!/usr/bin/env bash########################################################################
#   ________      ________      ________       ___  ___      ________      ________       #
#  |\   __  \    |\   __  \    |\   ____\     |\  \|\  \    |\   __  \    |\   ____\      #
#  \ \  \|\ /_   \ \  \|\  \   \ \  \___|_    \ \  \\\  \   \ \  \|\  \   \ \  \___|      #
#   \ \   __  \   \ \   __  \   \ \_____  \    \ \   __  \   \ \   _  _\   \ \  \         #
#    \ \  \|\  \   \ \  \ \  \   \|____|\  \    \ \  \ \  \   \ \  \\  \|   \ \  \____    #
#     \ \_______\   \ \__\ \__\    ____\_\  \    \ \__\ \__\   \ \__\\ _\    \ \_______\  #
#      \|_______|    \|__|\|__|   |\_________\    \|__|\|__|    \|__|\|__|    \|_______|  #
#                                 \|_________|                                            #
###########################################################################################
#
#───────────────────────────────────────────────────────────────────────────────(SOURCE)───
#───AUTO_RUN_INTERACTIVELY
[[ $- != *i* ]] && return

#───SOURCE_DEFINITIONS
[[ -f /etc/bashrc ]] && . /etc/bashrc

#───ENABLE_BASH_COMPLETIONS
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

#────────────────────────────────────────────────────────────────────────────────(THEME)───
powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

#──────────────────────────────────────────────────────────────────────────────(ALIASES)───
alias ll='ls -l --color=auto'
alias la='ls -la --color=auto'
alias grep='grep --color=auto'
alias logs="sudo find /var/log -type f -exec file {} + | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias rsync='rsync --recursive --progress'
alias ftext='clear && grep -niHIr --color=always "$1" "${2:-.}" | less -r'
alias alert='notify-send -u critical -a "$([ $? = 0 ] && echo TERMINAL || echo ERROR)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')" "Finished"'
alias wayland='--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto'
#───CHANGE_DIRECTORY
alias home='cd ~ || cd $HOME'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
#───ARCHIVE
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

#────────────────────────────────────────────────────────────────────────────(FUNCTIONS)───
#───EXPORT_ENVIRONMENT_VARIABLES
exp_env() {
	local VENDOR=($(lspci | grep -iE 'vga' | grep -ioE 'amd|nvidia|intel' | awk '{print tolower($0)}'))
	local INPUT="${1:-}"
	local W=0 X=0 A=0 N=0 I=0
	local ENLISTMENT=(
		"HISTSIZE=1000"
		"HISTFILESIZE=1000"
		"HISTCONTROL=erasedups:ignoredups:ignorespace"
		"EDITOR=codium -w"
		"GPG_TTY=$(tty)"
		"QT_QPA_PLATFORMTHEME=qt6ct"
		"QT_AUTO_SCREEN_SCALE_FACTOR=1"
		"_JAVA_AWT_WM_NONREPARENTING=1"
	)
	local WAYLAND=(
		"CLUTTER_BACKEND=wayland"
		"ECORE_EVAS_ENGINE=wayland"
		"ELM_ENGINE=wayland"
		"MOZ_ENABLE_WAYLAND=1"
		"QT_SCREEN_SCALE_FACTORS=1"			# FLAMESHOT
		"QT_QPA_PLATFORM=wayland;xcb"
		"QT_QPA_PLATFORMTHEME=wayland"
		"QT_WAYLAND_FORCE_DPI=physical"
		#"QT_WAYLAND_DISABLE_WINDOWDECORATION=1"	# DEFAULT: OFF
		"QT_WAYLAND_SHELL_INTEGRATION=layer-shell"
		"SDL_VIDEODRIVER=wayland"
		#"SDL_VIDEO_DRIVER=wayland"			# ONLY SET PER-STUTTERING STEAM GAME STEAM WON'T LAUNCH
		#"WAYLAND_DEBUG=1"				# EXPORT FOR DEBUGGING (1, client, server)
		#"XDG_SESSION_DESKTOP=Hyprland"			# EXPORT IF NOT DEFAULTING TO DE/WM
		#"XDG_CURRENT_DESKTOP=Hyprland"			# EXPORT IF NOT DEFAULTING TO DE/WM
		#"XDG_SESSION_TYPE=wayland"			# EXPORT IF NOT DEFAULTING TO WAYLAND
		#"GDK_BACKEND=wayland"				# EXPORT IF NOT DEFAULTING TO WAYLAND
		#"DISPLAY=$WAYLAND_DISPLAY"			# EXPORT FOR SPECIFIC APPS ($WAYLAND_DISPLAY:0)
	)
	local AMD=(
		"VDPAU_DRIVER=radeonsi"
		"LIBVA_DRIVER_NAME=radeonsi"
	)
	local NVIDIA=(
		"GBM_BACKEND=nvidia-drm"
		"__GLX_VENDOR_LIBRARY_NAME=nvidia"
		"LIBVA_DRIVER_NAME=nvidia"
		"__GL_GSYNC_ALLOWED"
		"__GL_VRR_ALLOWED"
		#"WLR_DRM_NO_ATOMIC=1"				# LEGACY DRM INTERFACE
	)
	local INTEL=("INTEL=no")
	local XORG=("XORG=no")

	#─CONCATENATE_VERIFIED_BACKENDS
    if [[ "$XDG_SESSION_TYPE" == "wayland" && "$W" -eq 0 ]]; then
        ENLISTMENT+=("${WAYLAND[@]}")
        ((W++))
    elif [[ "$XDG_SESSION_TYPE" == "x11" && "$X" -eq 0 ]]; then
        ENLISTMENT+=("${XORG[@]}")
        ((X++))
    else
        echo -e "\nUNKNOWN_BACKEND: [$XDG_SESSION_TYPE]"
    fi

	#─CONCATENATE_VERIFIED_GPUS
	for GPU in "${VENDOR[@]}"; do
	    if [[ "$GPU" == "amd" && "$A" -eq 0 ]]; then
	        ENLISTMENT+=("${AMD[@]}")
	        ((A++))
	    elif [[ "$GPU" == "nvidia" && "$N" -eq 0 ]]; then
	        ENLISTMENT+=("${NVIDIA[@]}")
	        ((N++))
	    elif [[ "$GPU" == "intel" && "$I" -eq 0 ]]; then
	        ENLISTMENT+=("${INTEL[@]}")
	        ((I++))
		#elif [[ "$A" -ge 1 || "$N" -ge 1 || "$I" -ge 1 ]]; then
		#	echo -e "\n[ GPUS_REPORT_SAME_VENDOR ]"
    	#else
		#	echo -e "\nUNKNOWN_GPU: [$GPU]"
	    fi
	done

	#─PROCESSES_USER_EXPORTATION
	case $INPUT in
		""|-[Hh]*|--[Hh]*)
			echo -e "\n-[ C/check  ]:\tCheck Available Exports"
			echo -e "-[ L/local  ]:\t[($UID) $USER] Environmental Export"
			echo -e "-[ G/global ]:\t[/etc/environment] Global Export\n"
		;;
		-[Cc]*|--[Cc]*)
			echo -e "\nChecking_Lists...\n##############################"
			for VARIABLE in "${ENLISTMENT[@]}"; do
				echo "$VARIABLE"
			done
			echo -e "##############################\n"
		;;
		-[Ll]*|--[Ll]*)
			echo -e "\nExporting to [($UID) $USER] environment\n"
    		for VARIABLE in "${ENLISTMENT[@]}"; do
				export "$VARIABLE"
    		done
		;;
		-[Gg]*|--[Gg]*)
        	echo -e "\nExporting to (/etc/environment)\n"
        	if [ -f /etc/environment ]; then
        	    for VARIABLE in "${ENLISTMENT[@]}"; do
        	        local NAME=${VARIABLE%%=*}
        	        if grep -q "$NAME=" /etc/environment; then
        	            sudo sed -i "s|^$NAME=.*|$VARIABLE|" /etc/environment
        	        else
        	            echo "$VARIABLE" | sudo tee -a /etc/environment
        	        fi
        	    done
        	else
        	    sudo touch /etc/environment
				echo -e "# Syntax: One "KEY=VAL" pair per-line\n#####################################" > /etc/environment
        	    chmod 644 /etc/environment
        	    chown root:root /etc/environment
        	    for VARIABLE in "${ENLISTMENT[@]}"; do
        	        echo "$VARIABLE" | tee -a /etc/environment
        	    done
        	fi
    	;;
		*)
			echo -e "\n🤷 ($1)\n$(exp_env -h)\n"
		;;
	esac
}
exp_env -local && clear

#──AUTOMATE_PACKAGES_INSTALLATION
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
					echo -e "\n🤷 ($1)\n$(install_packages -h)\n"
				;;
			esac
		;;
		-[Qq]*|--[Qq]*)
			return 1 && echo -e "\nExiting_Script\n\n##############################"
		;;
		*)
			echo -e "\n🤷 ($1)\n$(install_packages -h)\n"
		;;
	esac

	case $ID in
		#===(COPY_BETWEEN)=================================================================
		arch)
			# BETTER PACKAGE MANAGER INSTALLATION
    		if ! whereis yay &>/dev/null; then
    		    sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
    		    cd $HOME && find . -type d -name "yay-bin" -exec rm -fr "{}" +
    		    echo "[$DISTRO] Package Manager Installed: YAY!" 2>&1
				yay -Siq yay-bin
    		fi
			# "PACKAGES" INSTALLATION
			if whereis yay &>/dev/null; then
    		    yay -Syyu --needed - < $PACKAGED && sudo pacman-fix-permissions && yay -Ycc && yay -Sc --noconfirm
    		    notify-send -u low -a "PACKAGES" "[$DISTRO]: Updated & Packaged!"
    		    echo "[$DISTRO]: Updated & Packaged!" 2>&1
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

#───AUTOMATE_PACKAGES_BACKUPS
backup() {
	local PACKAGED="$(find . -type f -name PACKAGES)"
	local DAY="1"												# DAY OF THE WEEK

	if [ -n "$PACKAGED" ] && [ "$(date +%u)" = "$DAY" ]; then
		echo -e "#─UPDATED: $(date)" > "$PACKAGED"
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
backup
