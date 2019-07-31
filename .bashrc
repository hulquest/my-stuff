# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
set -o vi
STARS="****"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Ansible configuration
function set-ansible {
    if [[ ${PLATFORM} == *"Microsoft" ]] ; then
        PREFIX='/c/Users'
        SRC="${PREFIX}/khulques/src"
    else
        PREFIX='/home'
        SRC="${PREFIX}/khulques/src/projects"
    fi   

    export ANSIBLE_CONFIG=$HOME/ansible.cfg
    export ANSIBLE=${SRC}/ansible
    export ANSIBLE_LIBRARY=${ANSIBLE}/lib/ansible/modules
    echo "${STARS} START - Ansible configuration."
    . ${ANSIBLE}/hacking/env-setup
    echo "${STARS} COMPLETE - Ansible configuration - Check output."
}

function check-dotfiles {
    files=$(config diff --name-only master)
    if [[ -z ${files} ]] ; then
        echo "${STARS} Dot files are up to date"
    else
        for f in ${files} ; do
            echo "${STARS} Dot file [${f}] is out of date."
        done
    fi
}

# These are functions I pulled from a dev at Atlassian.  
# They can be used in situations like 'git status -s |col 2' to print the second column
# Something more complex is 'docker images |col 3 |xargs | skip 1' which can be used further ...
# A more complex time saver 'docker rmi $(docker images |col 3 |xargs skip 1)'
function col {
    awk -v col=$1 '{print $col}'
}

function skip {
    n=$(($1 +1))
    cut -d' ' -f${n}-
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
source ~/.git-completion.bash
source ~/.git-prompt.sh
export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\n\$ '
export IBUS_ENABLE_SYNC_MODE=1

function extract() {
    if [ -f "$1" ] ; then
        case "$1" in 
            *.tar.bz2)      tar xvjf "$1"                           ;;
            *.tar.gz)       tar xvzf "$1"                           ;;
            *.b2)           bunzip2 "$1"                            ;;
            *.rar)          unrar x "$1"                            ;;
            *.gz)           gunzip "$1"                             ;;
            *.tar)          tar xvf "$1"                            ;;
            *.tbz2)         tar xvjf "$1"                           ;;
            *.tgz)          tar xvzf "$1"                           ;;
            *.zip | *.ZIP)  unzip "$1"                              ;;
            *.pax)          cat "$1" |pax -r                        ;;
            *.pax.Z)        uncompress "$1" --stdout |pax -r        ;;
            *.Z)            uncompress "$1"                         ;;
            *.7z)           7z x -mmt8 "$1"                         ;;
            *)              echo "Don't know how to extract '$1'"   ;;
        esac
    else
        echo "extract: error $1 is not valid"
    fi
}
PLATFORM=$(uname -r)
if [[ ${PLATFORM} == *"Microsoft" ]] ; then
   echo "${STARS} Configure paths for WSL."
   # Need to install go locally on WSL (~/go) to get around Avecto nonsense.  Therefore go projects go here.
   # I might be able to figure this out but not right now.
   export GOPATH=/home/khulques/projects/go
else
   export GOPATH=/home/khulques/go

fi

export GOROOT=/usr/local/go
export PATH=${PATH}:${GOROOT}/bin:${GOPATH}/bin
check-dotfiles
PATH=${PATH}:$HOME/.local/bin

# GOLANG
export GOROOT=/usr/local/go # Same for WSL but in PoSH it is C:/Go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN

PATH=${PATH}:$(go env GOPATH)/bin
PATH=${PATH}:${HOME}/apps/helm:${HOME}/apps/tiller
