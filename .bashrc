#!/usr/bin/env bash
#
# ~/.bashrc
###########
#
#######################################################
# SOURCED
#######################################################
#
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
# ALIAS
#######################################################
#
# Aliases
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias sudo='sudo -v; sudo '
PS1='[\u@\h \W]\$ '
# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# Alias's for archives
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
# EXPORTS
#######################################################
#
# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace
# Envioronmental Variables
export _JAVA_AWT_WM_NONREPARENTING=1
export PATH=$HOME/bin:/usr/local/bin:$PATH
#export MANPATH="/usr/local/man:$MANPATH"
export HISTCONTROL=erasedups:ignoredups:ignorespace
export EDITOR="code -w"
export GPG_TTY=$(tty)

# Official WAY-(to_define_your)-LAND
if [[ $XDG_BACKEND == "wayland" ]]; then
    #export DISPLAY=$WAYLAND_DISPLAY          # ONLY EXPORT IF XWAYLAND=DISABLED
    #export XDG_RUNTIME_DIR=$XDG_SESSION_TYPE # GENERALLY /run/user/$UID
    #export GDK_BACKEND=$XDG_SESSION_TYPE
    export SDL_VIDEODRIVER=$XDG_SESSION_TYPE
    #export MOZ_ENABLE_WAYLAND=1 # USE BRAVE BROWSER APE
    #export QT_QPA_PLATFORM=$XDG_SESSION_TYPE # ONLY EXPORT IF REQUIRED
    #export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    #export XDG_CURRENT_DESKTOP=$XDG_SESSION_DESKTOP
    #export DESKTOP_SESSION=$XDG_SESSION_DESKTOP
    #export VDPAU_DRIVER=radeonsi
    #export LIBVA_DRIVER_NAME=radeonsi
fi

#######################################################
# THEME
#######################################################
#
# Theme
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

#######################################################
# SPECIAL FUNCTIONS
#######################################################
#
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
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
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
cpp() {
    rsync -r --progress "${1}" "${2}" 
}

# Automatically install the packages file
install_packages() {
	local DISTRO="$(hostnamectl | grep "Operating System:" | cut -c19-99)"
    
    if ! command -v "pacman" &>/dev/null; then
        notify-send -u critical -a "ERROR" "$DISTRO: NOT Arch Based" ||
        echo "$DISTRO: NOT Arch Based" 2>&1
        return 1
    else
        sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
        cd .. && rm -fr yay-bin
    fi

	if command -v "yay" &>/dev/null; then
        yay -Syyu --needed $(awk '{print $1}' packages) && yay -Ycc && yay -Sc && sudo pacman-fix-permissions && exit
        notify-send -u low -a "INSTALLED" "$DISTRO: Updated && Packaged" ||
        echo "$DISTRO: Updated && Packaged" 2>&1
    fi
}
