#!/usr/bin/env bash
#
# ~/.bashrc
###########
#
#######################################################
# SOURCED
#######################################################
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

#######################################################
# ALIASES
#######################################################
# Listing
alias ll='ls -l --color=auto'
alias la='ls -la --color=auto'
alias grep='grep --color=auto'
alias sudo='sudo -v; sudo '
PS1='[\u@\h \W]\$ '
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

#######################################################
# EXPORT ENVIRONMENTAL VARIABLES - (/etc/environment)
#######################################################
expenv() {
	local envlist=(
		"HISTSIZE=1000"
		"HISTFILESIZE=1000"
		"HISTCONTROL=erasedups:ignoredups:ignorespace"
		"EDITOR="codium -w""
		"GPG_TTY=$(tty)"
		"QT_QPA_PLATFORMTHEME=qt6ct"
		"QT_AUTO_SCREEN_SCALE_FACTOR=1"
		"_JAVA_AWT_WM_NONREPARENTING=1"
		"VDPAU_DRIVER=radeonsi"
		"LIBVA_DRIVER_NAME=radeonsi"
		"# FUTURE PLANS TO EASILY GLOBALIZE CONFIG CONDITIONS"
		"#TERMINAL=kitty --detach"
		"#SHELL=/usr/bin/fish"							# EITHER DEFAULTED OR (chsh -s /usr/bin/fish)
		"#MENU=wofi"
		"#EMOJI=wofi-emoji"
		"#CALC=wofi-calc"
		"#NETWORKMANAGER=nm-connection-editor"
		"#AUDIOCTL=pactl"
		"#AUDIOMANAGER=pavucontrol"
		"#POWERMENU='$HOME/.config/wofi/scripts/powermenu.sh'"
		"#BRIGHTNESSCTL=brightnessctl"
	)
	# Official WAY-(to_define_your)-LAND
	local daway=$(if [ $XDG_BACKEND == "wayland" ]; then sudo echo $envwaylist >> /etc/environment; fi)
	local envwaylist="
		#export WAYLAND_DEBUG=1						# (1, client, server)
		#XDG_CURRENT_DESKTOP=$XDG_SESSION_DESKTOP	# ONLY EXPORT IF NOT DEFAULTING TO WM/DE
		#GDK_BACKEND=$XDG_SESSION_TYPE				# ONLY EXPORT IF NOT DEFAULTING TO WAYLAND
		#DISPLAY=$WAYLAND_DISPLAY					# ONLY EXPORT FOR SPECIFIC APPLICATIONS ($WAYLAND_DISPLAY:0)
		SDL_VIDEODRIVER=$XDG_SESSION_TYPE
		QT_QPA_PLATFORM=wayland-egl
		QT_WAYLAND_FORCE_DPI=physical
		QT_WAYLAND_DISABLE_WINDOWDECORATION=0
		ECORE_EVAS_ENGINE=$XDG_SESSION_TYPE
		ELM_ENGINE=$XDG_SESSION_TYPE
		MOZ_ENABLE_WAYLAND=1
	"

	if [ -f /etc/environment ]; then
		sudo echo $envlist > /etc/environment && daway
	elif [ ! -f /etc/environment ]; then
		sudo touch /etc/environment
		sudo echo $envlist > /etc/environment && daway
	else
		for i in envlist; do
			export "${envlist[i]}"
		done
		for i in envwaylist; do
			export "${envwaylist[i]}"
		done
	fi
}

#######################################################
# THEME
#######################################################
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

#######################################################
# CUSTOM FUNCTIONS
#######################################################
# Extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "Requires manual extraction: '$archive'" ;;
			esac
		else
			echo "Invalid file: '$archive'"
		fi
	done
}

# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
rcp() {
    rsync -r --progress "${1}" "${2}" 
}

# Automatically install packages listed in the PACKAGES file
install_packages() {
	local DISTRO="$(cat /etc/os-release | grep -w "PRETTY_NAME" | cut -c14- | tr -d '"')"					# lsb_release -sd
	local ID="$(cat /etc/os-release | grep -w "ID" | cut -c4-)"
	local URL=(https://raw.githubusercontent.com/F7YYY/dotfiles/master/PACKAGES)	

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

	if [ ! -f PACKAGES ]; then
		echo -e "Downloading the latest repo:PACKAGES file into $(pwd)..."
		if [ -v wget &>/dev/null ]; then
			wget $URL
		elif [ -v curl &>/dev/null ]; then
			curl $URL -o PACKAGES
		else
			notify-send -u critical -a "ERROR" "WGET, CURL, & PACKAGES FILE NOT FOUND!" ||
			echo -e "\nPlease download:\n$URL\nOr create your own list of "PACKAGES" file.\n"
			return 1
		fi
	fi

	echo -e "\nObtained the latest repo:PACKAGES file:\n$(ll PACKAGES)\n\n##############################"

	case $ID in
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
		#"ID")
		#	Template (Copy>Paste>Modify) the "arch" case for your Distribution(s).
		#;;
		#<<PASTE_HERE
		*)
			notify-send -u critical -a "ERROR" "[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!" ||
    	    echo -e "\n[$DISTRO]: DISTRIBUTION NOT IMPLEMENTED!" 2>&1
			echo -e "\n😁 "Welcoming all new and improved commits!"\n"
    	    return 1
		;;
	esac
}
