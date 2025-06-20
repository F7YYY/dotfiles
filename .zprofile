#!/bin/zsh
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
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#───(FALLBACK)
# _______________________
# |[user@hostname]-[~]  |
# |─>>                  |
# |_____________________|
#
PS1="%{$fg[blue]%}%B[%b%{$fg[cyan]%}%n%{$fg[grey]%}%B@%b%{$fg[cyan]%}%m%{$fg[blue]%}%B]-%b%{$fg[blue]%}%B[%b%{$fg[white]%}%~%{$fg[blue]%}%B]%b
%{$fg[cyan]%}%B─>>%b%{$reset_color%} "
autoload -U colors && colors

#──────────────────────────────────────────────────(AUTO_COMPLETE)───
_comp_options+=(globdots)   # hidden files are included
HISTFILE=~/.bash_history
zmodload zsh/complist
setopt autocd beep extendedglob notify
zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' format '>>> %d'
#autoload -Uz compinit

#───(https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
plugins=(
  aliases
  alias-finder
  archlinux
  #autoenv
  autojump
  branch
  catimg
  colored-man-pages
  colorize
  command-not-found
  common-aliases
  cp
  emoji
  emoji-clock
  emotty
  extract
  fancy-ctrl-z
  gh
  git
  git-auto-fetch
  git-commit
  git-extras
  gitfast
  git-flow
  github
  gitignore
  #gitlfs
  git-prompt
  gnu-utils
  gpg-agent
  history
  history-substring-search
  jump
  keychain
  kitty
  nmap
  postgres
  rsync
  #starship
  sudo
  systemd
  #thefuck
  themes
  ufw
  vscode
  zbell
  zsh-interactive-cd
  zsh-navigation-tools
  #zsh-autocomplete
  #zsh-autosuggestions
  #zsh-navigation-tools
  #zsh-syntax-highlighting
)

#───────────────────────────────────────────────────────(KEYBINDS)───
#bindkey -e
#bindkey '^[[1~' beginning-of-line       # Home
#bindkey '^[[7~' beginning-of-line
#bindkey '^[[H' beginning-of-line
#bindkey '^[[4~' end-of-line             # End
#bindkey '^[[8~' end-of-line
#bindkey '^[[F' end-of-line
#bindkey '^[[3~' delete-char             # Delete
#bindkey '^[[C' forward-char             # →
#bindkey '^[[D' backward-char            # ←
#bindkey '^[[1;5C' forward-word          # Ctrl+→
#bindkey '^[[1;5D' backward-word         # Ctrl+←
#bindkey '^[Oc' forward-word
#bindkey '^[Od' backward-word
#bindkey '^H' backward-kill-word         # Ctrl+Backspace
#bindkey '^[[Z' undo                     # Shift+Tab
#bindkey '^[[5~' history-beginning-search-backward   # Page Up
#bindkey '^[[6~' history-beginning-search-forward    # Page Down
#autoload -Uz bindkey
