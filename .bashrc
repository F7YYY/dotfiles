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
#   BASH SPECIFIC SETUP
#
#   BASELINE CONFIG
#
#─────────────────────────────────────────────────────────────────────────────────────(THEME)───
#───(AUTO_RUN_INTERACTIVELY)
[[ $- != *i* ]] && return
#starship-theme

#───────────────────────────────────────────────────────────────────────────────────(ALIASES)───
alias c='clear'
alias l='ls -l --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -lahs --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ftext='clear && grep -niHIr --color=always "$1" "${2:-.}" | less -r'
alias curl='curl --user-agent "noleak"'
alias wget='wget -c --user-agent "noleak"'
alias rsync='rsync --recursive --progress'
alias logs='sudo find /var/log -type f -exec file {} + | grep "text" | cut -d " " -f1 | sed -e"s/:$//g" | grep -v "[0-9]$" | xargs tail -f'
alias alert='notify-send -u critical -a "$([ $? = 0 ] && echo TERMINAL || echo ERROR)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')" "Finished"'
alias free='free -h'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias df='df -h'
alias du='du -h'
alias dd='dd status=progress'
alias shred='shred -zf'
alias wayland='--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto'
#───(CHANGE_DIRECTORY)
alias home='cd ~ || cd "$HOME"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
#───(ARCHIVE)
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

if [[ -n "$BASH_VERSION" ]]; then
#───────────────────────────────────────────────────────────────────────────────────(SOURCES)───
  #───(SYSTEM CONFIG)
  [[ -r "/etc/bash.bashrc" ]] && source "/etc/bash.bashrc"
  #───(AUR: oh-my-bash-git)
  [[ -r "$OMB/oh-my-bash.sh" ]] && source "$OMB/oh-my-bash.sh"
  #───(AUR: starship)
  eval "$(starship init bash)"

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
  # Path to your oh-my-bash installation.
  export OMB=/usr/share/oh-my-bash
  
  # Set name of the theme to load. Optionally, if you set this to "random"
  # it'll load a random theme each time that oh-my-bash is loaded.
  OMB_THEME="powerbash10k"
  
  # If you set OMB_THEME to "random", you can ignore themes you don't like.
  # OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
  # You can also specify the list from which a theme is randomly selected:
  #OMB_THEME_RANDOM_CANDIDATES=("random")
  
  # Uncomment the following line to use case-sensitive completion.
  # OMB_CASE_SENSITIVE="true"
  
  # Uncomment the following line to use hyphen-insensitive completion. Case
  # sensitive completion must be off. _ and - will be interchangeable.
  # OMB_HYPHEN_SENSITIVE="false"
  
  # Uncomment the following line to disable bi-weekly auto-update checks.
  DISABLE_AUTO_UPDATE="true"
  
  # Uncomment the following line to change how often to auto-update (in days).
  # export UPDATE_OMB_DAYS=13
  
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
  
  # Would you like to use another custom folder than $OMB/custom?
  # OMB_CUSTOM=/path/to/new-custom-folder
  
  # To disable the uses of "sudo" by oh-my-bash, please set "false" to
  # this variable.  The default behavior for the empty value is "true".
  OMB_USE_SUDO=true
  
  # To enable/disable display of Python virtualenv and condaenv
  # OMB_PROMPT_SHOW_PYTHON_VENV=true
  # OMB_PROMPT_SHOW_PYTHON_VENV=false
  
  # To enable/disable Spack environment information
  OMB_PROMPT_SHOW_SPACK_ENV=true
  # OMB_PROMPT_SHOW_SPACK_ENV=false
  
  # Which completions would you like to load? (completions can be found in $OMB/completions/*)
  # Custom completions may be added to $OMB/custom/completions/
  # Example format: completions=(ssh git bundler gem pip pip3)
  # Add wisely, as too many completions slow down shell startup.
  completions=(
    defaults
    dirs
    gh
    git
    git_flow
    git_flow_avh
    composer
    ssh
    apm
    asdf
    awscli
    brew
    bundler
    capistrano
    chezmoi
    composer
    conda
    crc
    defaults
    dirs
    django
    docker
    docker-compose
    docker-machine
    drush
    fabric
    gem
    gh
    git
    git_flow_avh
    git_flow
    go
    gradle
    grunt
    gulp
    helm
    homesick
    hub
    jboss7
    jump
    jungle
    kontena
    kubectl
    makefile
    maven
    minikube
    npm
    nvm
    oc
    packer
    pip3
    pip
    projects
    rake
    salt
    sdkman
    ssh
    svn
    system
    terraform
    test_kitchen
    tkn
    tmux
    todo
    uv
    vagrant
    vault
    virtualbox
  )
  
  # Which aliases would you like to load? (aliases can be found in $OMB/aliases/*)
  # Custom aliases may be added to $OMB/custom/aliases/
  # Example format: aliases=(vagrant composer git-avh)
  # Add wisely, as too many aliases slow down shell startup.
  aliases=(
    cargo
    chmod
    debian
    docker
    general
    ls
    misc
    package-manager
    terraform
  )
  
  # Which plugins would you like to load? (plugins can be found in $OMB/plugins/*)
  # Custom plugins may be added to $OMB/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=(
    ansible
    asdf
    aws
    bashmarks
    bash-preexec
    battery
    brew
    bu
    cargo
    chezmoi
    colored-man-pages
    dotnet
    fzf
    gcloud
    git
    goenv
    golang
    kubectl
    npm
    nvm
    progress
    pyenv
    rbenv
    sdkman
    starship
    sudo
    vagrant
    xterm
  )
  
  # Which plugins would you like to conditionally load? (plugins can be found in $OMB/plugins/*)
  # Custom plugins may be added to $OMB/custom/plugins/
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
  # export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
  
  # Set personal aliases, overriding those provided by oh-my-bash libs,
  # plugins, and themes. Aliases can be placed here, though oh-my-bash
  # users are encouraged to define aliases within the OMB_CUSTOM folder.
  # For a full list of active aliases, run `alias`.
  #
  # Example aliases
  # alias bashconfig="mate $HOME/.bashrc"
  # alias ohmybash="mate $OMB"
  
  OMB_CACHE_DIR=$HOME/.cache/oh-my-bash
  if [[ ! -d $OMB_CACHE_DIR ]]; then
  	mkdir $OMB_CACHE_DIR
  fi
fi