#################################################
#                                               #
#     ███████╗███████╗██╗  ██╗██████╗  ██████╗  #
#     ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝  #
#       ███╔╝ ███████╗███████║██████╔╝██║       #
#      ███╔╝  ╚════██║██╔══██║██╔══██╗██║       #
#  ██╗███████╗███████║██║  ██║██║  ██║╚██████╗  #
#  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  #
#                                               #
#################################################
#
#   ZSH SPECIFIC SETUP
#
#   IMPORTS: .BASHRC & .BASH_PROFILE & .ZPROFILE
#
#────────────────────────────────────(SOURCES)───

#───(SOURCERER)
[[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"
[[ -f "$HOME/.bash_profile" ]] && source "$HOME/.bash_profile"
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
[[ -f "/etc/zsh/zprofile" ]] && source "/etc/zsh/zprofile"
[[ -f "/etc/zsh/zshrc" ]] && source "/etc/zsh/zshrc"
#───(AUR: zsh-autosuggestions)
[[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
#───(AUR: zsh-syntax-highlighting)
[[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
#───(STARSHIP)
#eval "$(starship init zsh)"

#──────────────────────────────(AUTO_COMPLETE)───
_comp_options+=(globdots)   # hidden files are included
HISTFILE="$HOME/.zsh_history"
HISTDUPE=erase
zmodload zsh/complist
setopt autocd beep extendedglob notify
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' menu select=0
zstyle ':completion:*' format '>>> %d'
autoload -Uz compinit

#───────────────────────────────────(KEYBINDS)───
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
#autoload -Uz bindkey

#──────────────────────────────────(OH_MY_ZSH)───
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "random" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  alias-finder
  ansible
  archlinux
  asdf
  battery
  bazel
  bgnotify
  branch
  colored-man-pages
  colorize
  command-not-found
  common-aliases
  cp
  #dircycle
  direnv
  dirhistory
  dirpersist
  docker
  docker-compose
  dotenv
  emoji
  emoji-clock
  emotty
  encode64
  extract
  fancy-ctrl-z
  fasd
  fastfile
  fbterm
  firewalld
  gh
  #git
  git-auto-fetch
  git-commit
  git-escape-magic
  git-extras
  gitfast
  git-flow-avh
  github
  git-hubflow
  gitignore
  git-lfs
  gnu-utils
  gpg-agent
  history
  history-substring-search
  keychain
  nmap
  otp
  please
  qrcode
  rand-quote
  rsync
  safe-paste
  screen
  #ssh
  #ssh-agent
  starship
  sudo
  supervisor
  systemadmin
  systemd
  timer
  tldr
  ufw
  vim-interaction
  vscode
  zsh-interactive-cd
  zsh-navigation-tools
)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#───(AUR: oh-my-zsh-git)
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
