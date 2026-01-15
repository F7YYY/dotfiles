#####################################################################
#                                                                   #
#     ███████╗██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗  #
#     ╚══███╔╝██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝  #
#       ███╔╝ ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗    #
#      ███╔╝  ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝    #
#  ██╗███████╗██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗  #
#  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝  #
#                                                                   #
#####################################################################
#
#────────────────────────────────────────────────────(SOURCES-BAK)───
#───(AUTO_RUN_INTERACTIVELY)
#[[ $- != *i* ]] && return    # SOURCED .ZSHRC
#───(SOURCERER)
#[[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"
#[[ -f "$HOME/.bash_profile" ]] && source "$HOME/.bash_profile"
#───(SOURCE_DEFINITIONS)
#[[ -f /etc/zsh/zprofile ]] && source /etc/zsh/zprofile
#───(OH-MY-ZSH)
#───(sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)")───#
#[[ -f /usr/share/oh-my-zsh/oh-my-zsh.sh ]] && source /usr/share/oh-my-zsh/oh-my-zsh.sh    # BROKEN-PACKAGE AUR:OH-MY-ZSH-GIT
#───(AUR: zsh-autocomplete)
#[[ -f /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] && source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
#───(AUR: zsh-autosuggestions)
#[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
#───(AUR: zsh-syntax-highlighting)
#[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#───(AUR: zsh-theme-powerlevel10k)
#[[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]] && source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

#──────────────────────────────────────────────────────────(THEME)───
#───(p10k configure)───#───(nvim $HOME/.p10k.zsh)───#
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of "$HOME/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# _______________________
# |[user@hostname]-[~]  |
# |─>> FALLBACK         |
# |_____________________|
#
PS1="%{$fg[blue]%}%B[%b%{$fg[cyan]%}%n%{$fg[grey]%}%B@%b%{$fg[cyan]%}%m%{$fg[blue]%}%B]-%b%{$fg[blue]%}%B[%b%{$fg[white]%}%~%{$fg[blue]%}%B]%b
%{$fg[cyan]%}%B─>>%b%{$reset_color%} "
autoload -U colors && colors

#──────────────────────────────────────────────────(AUTO_COMPLETE)───
_comp_options+=(globdots)   # hidden files are included
HISTFILE="$HOME/.bash_history"
zmodload zsh/complist
setopt autocd beep extendedglob notify
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' menu select=0
zstyle ':completion:*' format '>>> %d'
#autoload -Uz compinit

#───────────────────────────────────────────────────────(KEYBINDS)───
bindkey -e
bindkey '^[[1~' beginning-of-line       # Home
bindkey '^[[7~' beginning-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[4~' end-of-line             # End
bindkey '^[[8~' end-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char             # Delete
bindkey '^[[C' forward-char             # →
bindkey '^[[D' backward-char            # ←
bindkey '^[[1;5C' forward-word          # Ctrl+→
bindkey '^[[1;5D' backward-word         # Ctrl+←
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word
bindkey '^H' backward-kill-word         # Ctrl+Backspace
bindkey '^[[Z' undo                     # Shift+Tab
bindkey '^[[5~' history-beginning-search-backward   # Page Up
bindkey '^[[6~' history-beginning-search-forward    # Page Down
#autoload -Uz bindkey   # function definition file not found

#────────────────────────────────────────────────────────────(EWW)───
#compdef eww
autoload -U is-at-least
_eww() {
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
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
":: :_eww_commands" \
"*::: :->eww" \
&& ret=0
    case $state in
    (eww)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:eww-command-$line[1]:"
        case $line[1] in
            (shell-completions)
_arguments "${_arguments_options[@]}" \
'-s+[]:SHELL:(bash elvish fish powershell zsh)' \
'--shell=[]:SHELL:(bash elvish fish powershell zsh)' \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(daemon)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(logs)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(ping)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(update)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
'*::mappings -- variable_name="new_value"-pairs that will be updated:' \
&& ret=0
;;
(inspector)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(open)
_arguments "${_arguments_options[@]}" \
'--id=[]:ID: ' \
'--screen=[The identifier of the monitor the window should open on]:SCREEN: ' \
'-p+[The position of the window, where it should open. (i.e.\: 200x100)]:POS: ' \
'--pos=[The position of the window, where it should open. (i.e.\: 200x100)]:POS: ' \
'-s+[The size of the window to open (i.e.\: 200x100)]:SIZE: ' \
'--size=[The size of the window to open (i.e.\: 200x100)]:SIZE: ' \
'-a+[Sidepoint of the window, formatted like "top right"]:ANCHOR: ' \
'--anchor=[Sidepoint of the window, formatted like "top right"]:ANCHOR: ' \
'--duration=[Automatically close the window after a specified amount of time, i.e.\: 1s]:DURATION: ' \
'*--arg=[Define a variable for the window, i.e.\: \`--arg "var_name=value"\`]:ARGS: ' \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--toggle[If the window is already open, close it instead]' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
':window_name -- Name of the window you want to open:' \
&& ret=0
;;
(open-many)
_arguments "${_arguments_options[@]}" \
'*--arg=[Define a variable for the window, i.e.\: \`--arg "window_id\:var_name=value"\`]:ARGS: ' \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--toggle[If a window is already open, close it instead]' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
'*::windows -- List the windows to open, optionally including their id, i.e.\: `--window "window_name\:window_id"`:' \
&& ret=0
;;
(close)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
'*::windows:' \
&& ret=0
;;
(reload)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(kill)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(close-all)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(state)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'-a[Shows all variables, including not currently used ones]' \
'--all[Shows all variables, including not currently used ones]' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(get)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
':name:' \
&& ret=0
;;
(list-windows)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(active-windows)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(debug)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
&& ret=0
;;
(graph)
_arguments "${_arguments_options[@]}" \
'-c+[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--config=[override path to configuration directory (directory that contains eww.yuck and eww.(s)css)]:CONFIG:_files' \
'--debug[Write out debug logs. (To read the logs, run \`eww logs\`)]' \
'--force-wayland[Force eww to use wayland. This is a no-op if eww was compiled without wayland support]' \
'--logs[Watch the log output after executing the command]' \
'--no-daemonize[Avoid daemonizing eww]' \
'--restart[Restart the daemon completely before running the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_eww__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:eww-help-command-$line[1]:"
        case $line[1] in
            (shell-completions)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(daemon)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(logs)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(ping)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(update)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(inspector)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(open)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(open-many)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(close)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(reload)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(kill)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(close-all)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(state)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(get)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(list-windows)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(active-windows)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(debug)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(graph)
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

(( $+functions[_eww_commands] )) ||
_eww_commands() {
    local commands; commands=(
'shell-completions:Generate a shell completion script' \
'daemon:Start the Eww daemon' \
'logs:Print and watch the eww logs' \
'ping:Ping the eww server, checking if it is reachable' \
'update:Update the value of a variable, in a running eww instance' \
'inspector:Open the GTK debugger' \
'open:Open a window' \
'open-many:Open multiple windows at once. NOTE\: This will in the future be part of eww open, and will then be removed' \
'close:Close the given windows' \
'reload:Reload the configuration' \
'kill:Kill the eww daemon' \
'close-all:Close all windows, without killing the daemon' \
'state:Prints the variables used in all currently open window' \
'get:Get the value of a variable if defined' \
'list-windows:List the names of active windows' \
'active-windows:Show active window IDs, formatted linewise \`<window_id>\: <window_name>\`' \
'debug:Print out the widget structure as seen by eww' \
'graph:Print out the scope graph structure in graphviz dot format' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'eww commands' commands "$@"
}
(( $+functions[_eww__active-windows_commands] )) ||
_eww__active-windows_commands() {
    local commands; commands=()
    _describe -t commands 'eww active-windows commands' commands "$@"
}
(( $+functions[_eww__help__active-windows_commands] )) ||
_eww__help__active-windows_commands() {
    local commands; commands=()
    _describe -t commands 'eww help active-windows commands' commands "$@"
}
(( $+functions[_eww__close_commands] )) ||
_eww__close_commands() {
    local commands; commands=()
    _describe -t commands 'eww close commands' commands "$@"
}
(( $+functions[_eww__help__close_commands] )) ||
_eww__help__close_commands() {
    local commands; commands=()
    _describe -t commands 'eww help close commands' commands "$@"
}
(( $+functions[_eww__close-all_commands] )) ||
_eww__close-all_commands() {
    local commands; commands=()
    _describe -t commands 'eww close-all commands' commands "$@"
}
(( $+functions[_eww__help__close-all_commands] )) ||
_eww__help__close-all_commands() {
    local commands; commands=()
    _describe -t commands 'eww help close-all commands' commands "$@"
}
(( $+functions[_eww__daemon_commands] )) ||
_eww__daemon_commands() {
    local commands; commands=()
    _describe -t commands 'eww daemon commands' commands "$@"
}
(( $+functions[_eww__help__daemon_commands] )) ||
_eww__help__daemon_commands() {
    local commands; commands=()
    _describe -t commands 'eww help daemon commands' commands "$@"
}
(( $+functions[_eww__debug_commands] )) ||
_eww__debug_commands() {
    local commands; commands=()
    _describe -t commands 'eww debug commands' commands "$@"
}
(( $+functions[_eww__help__debug_commands] )) ||
_eww__help__debug_commands() {
    local commands; commands=()
    _describe -t commands 'eww help debug commands' commands "$@"
}
(( $+functions[_eww__get_commands] )) ||
_eww__get_commands() {
    local commands; commands=()
    _describe -t commands 'eww get commands' commands "$@"
}
(( $+functions[_eww__help__get_commands] )) ||
_eww__help__get_commands() {
    local commands; commands=()
    _describe -t commands 'eww help get commands' commands "$@"
}
(( $+functions[_eww__graph_commands] )) ||
_eww__graph_commands() {
    local commands; commands=()
    _describe -t commands 'eww graph commands' commands "$@"
}
(( $+functions[_eww__help__graph_commands] )) ||
_eww__help__graph_commands() {
    local commands; commands=()
    _describe -t commands 'eww help graph commands' commands "$@"
}
(( $+functions[_eww__help_commands] )) ||
_eww__help_commands() {
    local commands; commands=(
'shell-completions:Generate a shell completion script' \
'daemon:Start the Eww daemon' \
'logs:Print and watch the eww logs' \
'ping:Ping the eww server, checking if it is reachable' \
'update:Update the value of a variable, in a running eww instance' \
'inspector:Open the GTK debugger' \
'open:Open a window' \
'open-many:Open multiple windows at once. NOTE\: This will in the future be part of eww open, and will then be removed' \
'close:Close the given windows' \
'reload:Reload the configuration' \
'kill:Kill the eww daemon' \
'close-all:Close all windows, without killing the daemon' \
'state:Prints the variables used in all currently open window' \
'get:Get the value of a variable if defined' \
'list-windows:List the names of active windows' \
'active-windows:Show active window IDs, formatted linewise \`<window_id>\: <window_name>\`' \
'debug:Print out the widget structure as seen by eww' \
'graph:Print out the scope graph structure in graphviz dot format' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'eww help commands' commands "$@"
}
(( $+functions[_eww__help__help_commands] )) ||
_eww__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'eww help help commands' commands "$@"
}
(( $+functions[_eww__help__inspector_commands] )) ||
_eww__help__inspector_commands() {
    local commands; commands=()
    _describe -t commands 'eww help inspector commands' commands "$@"
}
(( $+functions[_eww__inspector_commands] )) ||
_eww__inspector_commands() {
    local commands; commands=()
    _describe -t commands 'eww inspector commands' commands "$@"
}
(( $+functions[_eww__help__kill_commands] )) ||
_eww__help__kill_commands() {
    local commands; commands=()
    _describe -t commands 'eww help kill commands' commands "$@"
}
(( $+functions[_eww__kill_commands] )) ||
_eww__kill_commands() {
    local commands; commands=()
    _describe -t commands 'eww kill commands' commands "$@"
}
(( $+functions[_eww__help__list-windows_commands] )) ||
_eww__help__list-windows_commands() {
    local commands; commands=()
    _describe -t commands 'eww help list-windows commands' commands "$@"
}
(( $+functions[_eww__list-windows_commands] )) ||
_eww__list-windows_commands() {
    local commands; commands=()
    _describe -t commands 'eww list-windows commands' commands "$@"
}
(( $+functions[_eww__help__logs_commands] )) ||
_eww__help__logs_commands() {
    local commands; commands=()
    _describe -t commands 'eww help logs commands' commands "$@"
}
(( $+functions[_eww__logs_commands] )) ||
_eww__logs_commands() {
    local commands; commands=()
    _describe -t commands 'eww logs commands' commands "$@"
}
(( $+functions[_eww__help__open_commands] )) ||
_eww__help__open_commands() {
    local commands; commands=()
    _describe -t commands 'eww help open commands' commands "$@"
}
(( $+functions[_eww__open_commands] )) ||
_eww__open_commands() {
    local commands; commands=()
    _describe -t commands 'eww open commands' commands "$@"
}
(( $+functions[_eww__help__open-many_commands] )) ||
_eww__help__open-many_commands() {
    local commands; commands=()
    _describe -t commands 'eww help open-many commands' commands "$@"
}
(( $+functions[_eww__open-many_commands] )) ||
_eww__open-many_commands() {
    local commands; commands=()
    _describe -t commands 'eww open-many commands' commands "$@"
}
(( $+functions[_eww__help__ping_commands] )) ||
_eww__help__ping_commands() {
    local commands; commands=()
    _describe -t commands 'eww help ping commands' commands "$@"
}
(( $+functions[_eww__ping_commands] )) ||
_eww__ping_commands() {
    local commands; commands=()
    _describe -t commands 'eww ping commands' commands "$@"
}
(( $+functions[_eww__help__reload_commands] )) ||
_eww__help__reload_commands() {
    local commands; commands=()
    _describe -t commands 'eww help reload commands' commands "$@"
}
(( $+functions[_eww__reload_commands] )) ||
_eww__reload_commands() {
    local commands; commands=()
    _describe -t commands 'eww reload commands' commands "$@"
}
(( $+functions[_eww__help__shell-completions_commands] )) ||
_eww__help__shell-completions_commands() {
    local commands; commands=()
    _describe -t commands 'eww help shell-completions commands' commands "$@"
}
(( $+functions[_eww__shell-completions_commands] )) ||
_eww__shell-completions_commands() {
    local commands; commands=()
    _describe -t commands 'eww shell-completions commands' commands "$@"
}
(( $+functions[_eww__help__state_commands] )) ||
_eww__help__state_commands() {
    local commands; commands=()
    _describe -t commands 'eww help state commands' commands "$@"
}
(( $+functions[_eww__state_commands] )) ||
_eww__state_commands() {
    local commands; commands=()
    _describe -t commands 'eww state commands' commands "$@"
}
(( $+functions[_eww__help__update_commands] )) ||
_eww__help__update_commands() {
    local commands; commands=()
    _describe -t commands 'eww help update commands' commands "$@"
}
(( $+functions[_eww__update_commands] )) ||
_eww__update_commands() {
    local commands; commands=()
    _describe -t commands 'eww update commands' commands "$@"
}

if [ "$funcstack[1]" = "_eww" ]; then
    _eww "$@"
else
    #compdef _eww eww
fi
