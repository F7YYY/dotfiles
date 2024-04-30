#!/usr/bin/env bash#######################################################################
#   ________      ________      ________       ___  ___      ________      ________      #
#  |\   __  \    |\   __  \    |\   ____\     |\  \|\  \    |\   __  \    |\   ____\     #
#  \ \  \|\ /_   \ \  \|\  \   \ \  \___|_    \ \  \\\  \   \ \  \|\  \   \ \  \___|     #
#   \ \   __  \   \ \   __  \   \ \_____  \    \ \   __  \   \ \   _  _\   \ \  \        #
#    \ \  \|\  \   \ \  \ \  \   \|____|\  \    \ \  \ \  \   \ \  \\  \|   \ \  \____   #
#     \ \_______\   \ \__\ \__\    ____\_\  \    \ \__\ \__\   \ \__\\ _\    \ \_______\ #
#      \|_______|    \|__|\|__|   |\_________\    \|__|\|__|    \|__|\|__|    \|_______| #
#                                 \|_________|                                           #
##########################################################################################
#
##########################################################################################
#	SOURCED
##########################################################################################
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

##########################################################################################
#	THEME
##########################################################################################
powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

##########################################################################################
# 	ALIASES
##########################################################################################
# Listing
alias ll='ls -l --color=auto'
alias la='ls -la --color=auto'
alias grep='grep --color=auto'
alias sudo='sudo -v; sudo '
# Changing directories
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# Archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

##########################################################################################
#	CUSTOM FUNCTIONS
##########################################################################################
# Copy file with a progress bar
rcp() {
	if command -v "rsync" &>/dev/null; then
		case $1 in
			""|[Hh]*[Pp]|-h*p|--h*p)
				rsync --help
			;;
			*)
				rsync --recursive --progress "${1}" "${2:-.}"
			;;
		esac
	else
		echo -e "\nPackege not found: rsync\nhttps://rsync.samba.org/\n"
	fi
}

# Where the FUCK is that TEXT at!
ftext() {
	case $1 in
		""|[Hh]*[Pp]|-h*p|--h*p)
			echo -e "\nUsage: ftext [1] [2]"
			echo -e "\n- [1]\tMandatory keyword to index\n- [2]\tOptional Path/File to iterate recursively\n\tDefault: [$(pwd)]\n"
		;;
		*)
			clear && grep -niHIr --color=always "$1" "${2:-.}" | less -r
		;;
	esac
}

# Export your environment variables Globally or Locally
exp_env() {
	# General Variables
	local enlist=(
		"HISTSIZE=1000"
		"HISTFILESIZE=1000"
		"HISTCONTROL=erasedups:ignoredups:ignorespace"
		"EDITOR=codium -w"
		"GPG_TTY=$(tty)"
		"QT_QPA_PLATFORMTHEME=qt6ct"
		"QT_AUTO_SCREEN_SCALE_FACTOR=1"
		"_JAVA_AWT_WM_NONREPARENTING=1"
		"VDPAU_DRIVER=radeonsi"
		"LIBVA_DRIVER_NAME=radeonsi"
	)
	# WAY-(to_define_your)-LAND Variables
	local enlistway=(
		#"WAYLAND_DEBUG=1"								# (1, client, server)
		#"XDG_CURRENT_DESKTOP=$XDG_SESSION_DESKTOP"		# ONLY EXPORT IF NOT DEFAULTING TO WM/DE
		#"GDK_BACKEND=$XDG_SESSION_TYPE"				# ONLY EXPORT IF NOT DEFAULTING TO WAYLAND
		#"DISPLAY=$WAYLAND_DISPLAY"						# ONLY EXPORT FOR SPECIFIC APPLICATIONS ($WAYLAND_DISPLAY:0)
		"SDL_VIDEODRIVER=$XDG_SESSION_TYPE"
		"QT_QPA_PLATFORM=wayland-egl"
		"QT_WAYLAND_FORCE_DPI=physical"
		"QT_WAYLAND_DISABLE_WINDOWDECORATION=0"
		"ECORE_EVAS_ENGINE=$XDG_SESSION_TYPE"
		"ELM_ENGINE=$XDG_SESSION_TYPE"
		"MOZ_ENABLE_WAYLAND=1"
	)

	# Verify Distros backend for list(s)
	if [ "$XDG_BACKEND" == "wayland" ]; then
		enlist+=("${enlistway[@]}")
	fi
	
	# Processes user's exportation process
	case $1 in
		""|[lL]*)
			echo -e "\nExporting to ($UID) $USER\n"
    		for variable in "${enlist[@]}"; do
    		    if [[ ! $variable == "#"* ]]; then
    		        export "$variable"
    		    fi
    		done
		;;
		[gG]*)
			echo -e "\nExporting to (/etc/environment)\n"
			if [ -f /etc/environment ]; then
				for variable in "${enlist[@]}"; do
				    if [[ "$variable" != "#"* && ! $(grep -q "^$variable$" /etc/environment) ]]; then
				        echo "$variable" | pkexec tee -a /etc/environment &>/dev/null
				    fi
				done
			else
				pkexec touch /etc/environment &&
				chmod 644 /etc/environment &&
				chown root:root /etc/environment
				exp_env global
			fi
		;;
		*)
			echo -e "\n🤷 ($1)\n\nexp_env [L/Local|g/global]\n - L/Local\tExports to ($UID) $USER\n - g/global\tExports to (/etc/environment)\n\nDefault: Local - At Login & Reload\n"
		;;
	esac
}
exp_env local && clear

# Automatically install packages listed in the PACKAGES file
install_packages() {
	local DISTRO="$(cat /etc/os-release | grep -w "PRETTY_NAME" | cut -c14- | tr -d '"')"					# lsb_release -sd
	local ID="$(cat /etc/os-release | grep -w "ID" | cut -c4-)"
	local URL=(https://raw.githubusercontent.com/F7YYY/dotfiles/master/PACKAGES)
	local PACKAGED="$(find . -type f -name PACKAGES)"

	cd $HOME || ~
	echo "
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
##############################
Home:		$(pwd)
Distribution:	$DISTRO
Architecture:	$ID
##############################
"
	if [ ! -f "$PACKAGED" ]; then
		echo -e "Downloading the latest [$URL] -> [$(pwd)]"
		if [ -v wget &>/dev/null ]; then
			wget $URL
			echo -e "\nObtained the latest PACKAGES\nURL: [$URL]\nPATH: [$PACKAGED]\n\n##############################"
		elif [ -v curl &>/dev/null ]; then
			curl $URL -o PACKAGES
			echo -e "\nObtained the latest PACKAGES\nURL: [$URL]\nPATH: [$PACKAGED]\n\n##############################"
		else
			notify-send -u critical -a "ERROR" "WGET & CURL NOT FOUND - Manual Download/Creation Required!" ||
			echo -e '\n- WGET & CURL NOT FOUND!\n- Manual Download/Creation Required!\n'
		fi
		echo -e " - R/Retry\tAlready created personal "PACKAGES"\n\t\tAlready downloaded: [$URL]\n\t\tRerun the script"
		echo -e " - c/create\tHelp create my own personal "PACKAGES" list"
		echo -e " - e/exit\tExit Script"
		read -p "[R/Retry|c/create|e/exit]: " rc
		case $rc in
			""|[rR]*)
				return 1 && install_packages
			;;
			[cC]*)
				touch $HOME/PACKAGES && echo "# LIST ONE PACKAGE PER-LINE BELOW" >> $HOME/PACKAGES
				echo -e "\nOPTION:\tEDIT ['$PACKAGED']\n[Y/Yes]\t- '${EDITOR:-vim}'\n[n/no]\t- Manually\n\n"
				read -p "?: " edit
				case $edit in
					""|[yY]*)
						if ! command -v "$EDITOR" &>/dev/null; then
							$EDITOR $PACKAGED
						elif command -v "nvim" &>/dev/null; then
							nvim $PACKAGED
						elif command -v "vim" &>/dev/null; then
							vim $PACKAGED
						else
							echo -e "\n- Editor not exported\n- NeoVim & Vim not available\n\n> Manual editing maybe required after listing [$PACKAGED] <\n\n##############################"
							read -p "List Packages: " LIST
							tr ' ' '\n' <<< "$LIST" >> "$PACKAGED"
						fi
					;;
					[eE]*)
						return 1 && echo -e "\nExiting script\n\n##############################"
					;;
					*)
						return 1 && echo -e "\nExiting script for manual [$PACKED] editing\n\n##############################"
					;;
				esac
			;;
			*)
				echo -e "\n🤷 ($1)\n\ninstall_packages [R/retry|c/create|q/quit]"
			;;
		esac
	fi

	case $ID in
		*)
			notify-send -u critical -a "ERROR" "[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!" ||
    	    echo -e "\n[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!" 2>&1
			echo -e "\n😁 "Welcoming all new and improved commits!"\n"
    	    return 1
		;;
		# ======
		"arch")
			# Install a better package manager
    		if ! command -v "yay" &>/dev/null; then
    		    sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
    		    cd $HOME && sudo find / -type d -name "yay-bin" -exec rm -fr "{}" +
    		    echo "[$DISTRO] Package Manager installed: YAY!" 2>&1
				yay -Siq yay-bin
    		fi
			# Installs packages listed in PACKAGES file
			if command -v yay &>/dev/null; then
    		    yay -Syyu --needed --removemake --cleanafter - < PACKAGES && yay -Ycc && yay -Sc && sudo pacman-fix-permissions
    		    notify-send -u low -a "PACKAGES" "[$DISTRO]: Updated && Packaged!" ||
    		    echo "[$DISTRO]: Updated && Packaged!" 2>&1
    		fi
		;;
		# ====== (COPY>PASTE>MODIFY) BETWEEN (# ======) BELOW THIS LINE FOR YOUR DISTRIBUTION(S)
	esac
}
