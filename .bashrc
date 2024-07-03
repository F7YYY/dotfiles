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
###########################################################################################
#	SOURCE
###########################################################################################
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

###########################################################################################
#	THEME
###########################################################################################
powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

###########################################################################################
# 	ALIASES
###########################################################################################
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
# Add an "alert" alias for long running commands, I.E.: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# Run applications under Wayland
alias wayland='--enable-features=UseOzonePlatform --ozone-platform=wayland'
alias rcp='rsync --recursive --progress'
alias rmv='rsync --recursive --progress'
alias ftext='clear && grep -niHIr --color=always "$1" "${2:-.}" | less -r'

###########################################################################################
# 	FUNCTIONS
###########################################################################################
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
		"QT_SCREEN_SCALE_FACTORS='1;1'"					# FLAMESHOT
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
		""|-[Hh]|--[Hh]*)
			echo -e "\nDefault: Local - At Login & Reload\n"
			echo -e "- L/local\tExports to ($UID) $USER"
			echo -e "- G/global\tExports to (/etc/environment)\n"
		;;
		-[Ll]*|--[Ll]*)
			echo -e "\nExporting to ($UID) $USER\n"
    		for variable in "${enlist[@]}"; do
    		    if [[ ! $variable == "#"* ]]; then
    		        export "$variable"
    		    fi
    		done
		;;
		-[Gg]*|--[Gg]*)
			echo -e "\nExporting to (/etc/environment)\n"
			if [ -f /etc/environment ]; then
				for variable in "${enlist[@]}"; do
				    if [[ "$variable" != "#"* && ! $(grep -q "^$variable$" /etc/environment) ]]; then
				        echo "$variable" | pkexec tee -a /etc/environment 
				    fi
				done
			else
				pkexec touch /etc/environment
				chmod 644 /etc/environment
				chown root:root /etc/environment
				exp_env global
			fi
		;;
		*)
			echo -e "\n🤷 ($1)\n\nexp_env [ H/help | L/local | G/global ]"
		;;
	esac
}
exp_env -local && clear

# Automatically install packages listed in the PACKAGES file
install_packages() {
	local DISTRO="$(grep -w "^PRETTY_NAME" /etc/os-release | cut -d '"' -f 2)"	# lsb_release -sd
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
😁 Welcoming improved commits!
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
			echo -e "[ R/retry ]:\tRerun Script"
			echo -e "[ C/create ]:\tCreate personalized "PACKAGES" list [DEFAULT]"
			echo -e "[ Q/quit ]:\tExit Script\n"
			read -p "?: " rce
			case $rce in
				[Rr]*)
					echo -e "\nRETRYING_SCRIPT\n"
					return 1 && install_packages
				;;
				""|[Cc]*)
					echo -e "#─LIST_ONE_PACKAGE_PER-LINE\n" > $HOME/.config/PACKAGES
					echo -e "\nOPTION:\tEDIT [ '$PACKAGED' ]\n"
					echo -e "[ E/edit ]:\t'${EDITOR}'"
					echo -e "[ Q/quit ]:\tExit & Manually Edit\n"
					read -p "?: " edit
					case $edit in
						""|[Ee]*)
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
								read -p "List Packages: " LIST
								tr ' ' '\n' <<< "$LIST" >> "$PACKAGED"
							fi
						;;
						[Qq]*)
							return 1 && echo -e "\nExiting_Script\n\n##############################"
						;;
						*)
							echo -e "\n🤷 ($1)\n\ninstall_packages [ E/edit | Q/quit ]\n"
						;;
					esac
				;;
				[Qq]*)
					return 1 && echo -e "\nExiting_Script\n\n##############################"
				;;
				*)
					echo -e "\n🤷 ($1)\n\ninstall_packages [ R/retry | C/create| Q/quit ]\n"
				;;
			esac
		fi
	elif [ -f "$PACKAGED" &>/dev/null ]; then
		echo -e "Obtained the latest PACKAGES"
		echo -e "PATH: [$PACKAGED]\n"
		echo -e "##############################\n"
	else
		return 1 && echo -e "\n_WTF_\n"
	fi

	case $ID in
		#===(COPY_BETWEEN)=================================================================
		arch)
			# Install a better package manager
    		if ! whereis yay &>/dev/null; then
    		    sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
    		    cd $HOME && find . -type d -name "yay-bin" -exec rm -fr "{}" +
    		    echo "[$DISTRO] Package Manager installed: YAY!" 2>&1
				yay -Siq yay-bin
    		fi
			# Installs packages listed in PACKAGES file
			if whereis yay &>/dev/null; then
    		    yay -Syyu --needed --removemake --cleanafter - < $PACKAGED && sudo pacman-fix-permissions && yay -Ycc && yay -Sc --noconfirm
    		    notify-send -u low -a "PACKAGES" "[$DISTRO]: Updated & Packaged!"
    		    echo "[$DISTRO]: Updated & Packaged!" 2>&1
    		fi
		;;
		#===(PASTE_UNDERNEATH)=============================================================
		#	PASTE_HERE
		#===(MODIFY_FOR_YOUR_DISTRIBUTION)=================================================
		*)
			notify-send -u critical -a "ERROR" "[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!"
    	    echo -e "[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!\n" 2>&1
    	    return 1
		;;
	esac
}

#─BACKUP_PACKAGES
backup() {
	local PACKAGED="$(find . -type f -name PACKAGES)"
	local day="3"	# DAY OF THE WEEK

	if [ -n "$PACKAGED" ] && [ "$(date +%u)" = "$day" ]; then
		echo -e "#─UPDATED: $(date)" > "$PACKAGED"
		if whereis yay &>/dev/null; then
			yay -Qqe >> "$PACKAGED"
		elif whereis pacman &>/dev/null; then
			pacman -Qqe >> "$PACKAGED"
		else
			echo -e "\nI uSe ArCh BtW!\n"
		fi
	fi

	if [ "$(date +%u)" = "$day" ]; then
		git dotfiles cam "AUTO-BACKUP"
		git gui --prompt dotfiles psom	# CONFIGURE GUI 
	fi
}
backup
