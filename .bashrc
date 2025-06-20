#!/bin/bash
################################################################################################
#        ________      ________      ________       ___  ___      ________      ________       #
#       |\   __  \    |\   __  \    |\   ____\     |\  \|\  \    |\   __  \    |\   ____\      #
#       \ \  \|\ /_   \ \  \|\  \   \ \  \___|_    \ \  \\\  \   \ \  \|\  \   \ \  \___|      #
#        \ \   __  \   \ \   __  \   \ \_____  \    \ \   __  \   \ \   _  _\   \ \  \         #
#   ___   \ \  \|\  \   \ \  \ \  \   \|____|\  \    \ \  \ \  \   \ \  \\  \|   \ \  \____    #
#  |\__\   \ \_______\   \ \__\ \__\    ____\_\  \    \ \__\ \__\   \ \__\\ _\    \ \_______\  #
#  \|__|    \|_______|    \|__|\|__|   |\_________\    \|__|\|__|    \|__|\|__|    \|_______|  #
#                                      \|_________|                                            #
#                                                                                              #
################################################################################################
#
#───────────────────────────────────────────────────────────────────────────────────(SOURCES)───
#───(AUTO_RUN_INTERACTIVELY)
[[ $- != *i* ]] && return
#───(SOURCERER)
[[ -f "$HOME/.bash_bashrc" ]] && source "$HOME/.bash_profile"
#───(SOURCE_DEFINITIONS)
[[ -f /etc/bash.bashrc ]] && source /etc/bash.bashrc
#───(bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)")────#
#[[ -f /usr/share/oh-my-bash/oh-my-bash.sh ]] && source /usr/share/oh-my-bash/oh-my-bash.sh      # BROKEN-PACKAGE AUR:OH-MY-BASH-GIT
#───(ENABLE_BASH_COMPLETIONS)
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

#──────────────────────────────────────────────────────────────────────────────────(KEYBINDS)───
bind '"\e[1~": beginning-of-line'         # Home
bind '"\e[7~": beginning-of-line'
bind '"\e[H": beginning-of-line'
bind '"\e[4~": end-of-line'               # End
bind '"\e[8~": end-of-line'
bind '"\e[F": end-of-line'
bind '"\e[3~": delete-char'               # Delete
bind '"\e[C": forward-char'               # →
bind '"\e[D": backward-char'              # ←
bind '"\e[1;5C": forward-word'            # Ctrl+→
bind '"\e[1;5D": backward-word'           # Ctrl+←
bind '"\C-h": backward-kill-word'         # Ctrl+Backspace
bind '"\e[Z": undo'                       # Shift+Tab = undo
bind '"\e[5~": history-search-backward'   # Page Up
bind '"\e[6~": history-search-forward'    # Page Down

#────────────────────────────────────────────────────────────────────────────────(OH_MY_BASH)───
# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH="$HOME/.oh-my-bash"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
#OSH_THEME="powerbash10k"
OSH_THEME="powerline-multiline"

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
# You can also specify the list from which a theme is randomly selected:
# OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_OSH_DAYS=1

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/usr/share/oh-my-bash

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=false

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# To enable/disable Spack environment information
# OMB_PROMPT_SHOW_SPACK_ENV=true  # enable
# OMB_PROMPT_SHOW_SPACK_ENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  defaults
  dirs
  gh
  git
  git_flow_avh
  git_flow
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  #composer   # module 'alias:composer' not found.
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  bashmarks
  colored-man-pages
  git
  jump
  progress
  #starship    # [oh-my-bash] starship not found, please install it from https://github.com/starship/starship
  sudo
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

# If you want to reduce the initialization cost of the "tput" command to
# initialize color escape sequences, you can uncomment the following setting.
# This disables the use of the "tput" command, and the escape sequences are
# initialized to be the ANSI version:
#
#OMB_TERM_USE_TPUT=no

source "$OSH/oh-my-bash.sh"

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"
