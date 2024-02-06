# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
#ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
#zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
#zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 1

# Uncomment the following line if pasting URLs and other text is messed up.
#DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
#DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
#DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# Envioronmental Variables
export _JAVA_AWT_WM_NONREPARENTING=1
export PATH=$HOME/bin:/usr/local/bin:$PATH
#export MANPATH="/usr/local/man:$MANPATH"
export HISTCONTROL=erasedups:ignoredups:ignorespace
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="code -w"
export GPG_TTY=$(tty)
export SUDO_PROMPT=$'\a[sudo] please enter a password: '
#export LANG=en_US.UTF-8
#export ARCHFLAGS="-arch x86_64"

# Official WAY- to_define_your -LAND
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    #export DISPLAY=$WAYLAND_DISPLAY          # ONLY EXPORT IF XWAYLAND=DISABLED
    #export XDG_RUNTIME_DIR=$XDG_SESSION_TYPE # GENERALLY /run/user/$UID
    export GDK_BACKEND=$XDG_SESSION_TYPE
    export SDL_VIDEODRIVER=$XDG_SESSION_TYPE
    #export MOZ_ENABLE_WAYLAND=1 # USE BRAVE BROWSER APE
    #export QT_QPA_PLATFORM=$XDG_SESSION_TYPE # ONLY EXPORT IF REQUIRED
    #export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export XDG_CURRENT_DESKTOP=$XDG_SESSION_DESKTOP
    export DESKTOP_SESSION=$XDG_SESSION_DESKTOP
    export VDPAU_DRIVER=radeonsi
    export LIBVA_DRIVER_NAME=radeonsi
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
#alias zshconfig="mate ~/.zshrc"
#alias ohmyzsh="mate ~/.oh-my-zsh"

# Aliases
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias sudo='sudo -v; sudo '
PS1='[\u@\h \W]\$ '

# Sourcing ZSH
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.


#compdef libredefender

autoload -U is-at-least

_libredefender() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'-D+[]:DATA:_files' \
'--data=[]:DATA:_files' \
'-q[Only show warnings]' \
'--quiet[Only show warnings]' \
'*-v[More verbose logs]' \
'*--verbose[More verbose logs]' \
'-C[]' \
'--colors[]' \
'-h[Print help]' \
'--help[Print help]' \
":: :_libredefender_commands" \
"*::: :->libredefender" \
&& ret=0
    case $state in
    (libredefender)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:libredefender-command-$line[1]:"
        case $line[1] in
            (scan)
_arguments "${_arguments_options[@]}" \
'-j+[Configure the number of scanning threads, defaults to number of cpu cores]:CONCURRENCY: ' \
'--concurrency=[Configure the number of scanning threads, defaults to number of cpu cores]:CONCURRENCY: ' \
'-D+[]:DATA:_files' \
'--data=[]:DATA:_files' \
'-q[Only show warnings]' \
'--quiet[Only show warnings]' \
'*-v[More verbose logs]' \
'*--verbose[More verbose logs]' \
'-C[]' \
'--colors[]' \
'-h[Print help]' \
'--help[Print help]' \
'*::paths -- Paths that should be scanned:_files' \
&& ret=0
;;
(scheduler)
_arguments "${_arguments_options[@]}" \
'-D+[]:DATA:_files' \
'--data=[]:DATA:_files' \
'-q[Only show warnings]' \
'--quiet[Only show warnings]' \
'*-v[More verbose logs]' \
'*--verbose[More verbose logs]' \
'-C[]' \
'--colors[]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(infections)
_arguments "${_arguments_options[@]}" \
'-D+[]:DATA:_files' \
'--data=[]:DATA:_files' \
'-d[Interactively offer deletion for every file]' \
'--delete[Interactively offer deletion for every file]' \
'--delete-all[Delete all files without further confirmation (DANGER!)]' \
'-q[Only show warnings]' \
'--quiet[Only show warnings]' \
'*-v[More verbose logs]' \
'*--verbose[More verbose logs]' \
'-C[]' \
'--colors[]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(test-notify)
_arguments "${_arguments_options[@]}" \
'-D+[]:DATA:_files' \
'--data=[]:DATA:_files' \
'-q[Only show warnings]' \
'--quiet[Only show warnings]' \
'*-v[More verbose logs]' \
'*--verbose[More verbose logs]' \
'-C[]' \
'--colors[]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(dump-config)
_arguments "${_arguments_options[@]}" \
'-D+[]:DATA:_files' \
'--data=[]:DATA:_files' \
'-q[Only show warnings]' \
'--quiet[Only show warnings]' \
'*-v[More verbose logs]' \
'*--verbose[More verbose logs]' \
'-C[]' \
'--colors[]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(completions)
_arguments "${_arguments_options[@]}" \
'-D+[]:DATA:_files' \
'--data=[]:DATA:_files' \
'-q[Only show warnings]' \
'--quiet[Only show warnings]' \
'*-v[More verbose logs]' \
'*--verbose[More verbose logs]' \
'-C[]' \
'--colors[]' \
'-h[Print help]' \
'--help[Print help]' \
':shell:(bash elvish fish powershell zsh)' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_libredefender__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:libredefender-help-command-$line[1]:"
        case $line[1] in
            (scan)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(scheduler)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(infections)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(test-notify)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(dump-config)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(completions)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_libredefender_commands] )) ||
_libredefender_commands() {
    local commands; commands=(
'scan:Scan directories for signature matches' \
'scheduler:Run a background service that scans periodically' \
'infections:List threats that have been detected' \
'test-notify:Send a test notification' \
'dump-config:Load the configuration and print it as json for debugging' \
'completions:Generate shell completions' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'libredefender commands' commands "$@"
}
(( $+functions[_libredefender__completions_commands] )) ||
_libredefender__completions_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender completions commands' commands "$@"
}
(( $+functions[_libredefender__help__completions_commands] )) ||
_libredefender__help__completions_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender help completions commands' commands "$@"
}
(( $+functions[_libredefender__dump-config_commands] )) ||
_libredefender__dump-config_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender dump-config commands' commands "$@"
}
(( $+functions[_libredefender__help__dump-config_commands] )) ||
_libredefender__help__dump-config_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender help dump-config commands' commands "$@"
}
(( $+functions[_libredefender__help_commands] )) ||
_libredefender__help_commands() {
    local commands; commands=(
'scan:Scan directories for signature matches' \
'scheduler:Run a background service that scans periodically' \
'infections:List threats that have been detected' \
'test-notify:Send a test notification' \
'dump-config:Load the configuration and print it as json for debugging' \
'completions:Generate shell completions' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'libredefender help commands' commands "$@"
}
(( $+functions[_libredefender__help__help_commands] )) ||
_libredefender__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender help help commands' commands "$@"
}
(( $+functions[_libredefender__help__infections_commands] )) ||
_libredefender__help__infections_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender help infections commands' commands "$@"
}
(( $+functions[_libredefender__infections_commands] )) ||
_libredefender__infections_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender infections commands' commands "$@"
}
(( $+functions[_libredefender__help__scan_commands] )) ||
_libredefender__help__scan_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender help scan commands' commands "$@"
}
(( $+functions[_libredefender__scan_commands] )) ||
_libredefender__scan_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender scan commands' commands "$@"
}
(( $+functions[_libredefender__help__scheduler_commands] )) ||
_libredefender__help__scheduler_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender help scheduler commands' commands "$@"
}
(( $+functions[_libredefender__scheduler_commands] )) ||
_libredefender__scheduler_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender scheduler commands' commands "$@"
}
(( $+functions[_libredefender__help__test-notify_commands] )) ||
_libredefender__help__test-notify_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender help test-notify commands' commands "$@"
}
(( $+functions[_libredefender__test-notify_commands] )) ||
_libredefender__test-notify_commands() {
    local commands; commands=()
    _describe -t commands 'libredefender test-notify commands' commands "$@"
}

if [ "$funcstack[1]" = "_libredefender" ]; then
    _libredefender "$@"
else
    compdef _libredefender libredefender
fi

