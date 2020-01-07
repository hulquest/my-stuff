#!/bin/bash
# FIND setup script at: https://gist.github.com/hulquest/7b370ebd5ca482a001fe30805c372710
PLATFORM=$(uname -r)
if [[ ${PLATFORM} == *"Microsoft" ]] ; then
   echo "${STARS} Configuring aliases for WSL"
   prefix="/c/Users/khulques"
   src="src"
   alias docker=docker.exe
   alias 'go'=/c/go/bin/go.exe
   alias k=kubectl.exe
else
   echo "${STARS} Configuring aliases for generic Linux"
   prefix="~"
   src="src/projects"
   alias mk=minikube
   alias k=kubectl
   export GPG_TTY=$(tty) # For signing git commits
fi

# Ansible configuration
function set-ansible {
    if [[ ${PLATFORM} == *"Microsoft" ]] ; then
        PREFIX='/c/Users'
        SRC="${PREFIX}/khulques/src"
    else
        PREFIX='/home'
        SRC="${HOME}/src/projects"
    fi   

    export ANSIBLE_CONFIG=$HOME/ansible.cfg
    export ANSIBLE=${SRC}/ansible
    export ANSIBLE_LIBRARY=${ANSIBLE}/lib/ansible/modules
    echo "${STARS} START - Ansible configuration."
    source ${ANSIBLE}/venv/bin/activate
    . ${ANSIBLE}/hacking/env-setup
    echo "${STARS} COMPLETE - Ansible configuration - Check output."
}

alias lr='ls -ltr'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gv=gvim
alias pip3=/usr/bin/pip3
alias src="cd ${prefix}/${src}"
alias sfp="cd ${prefix}/${src}/sfprime"
alias nma="cd ${prefix}/${src}/hci-monitor"
alias cfg="cd ${prefix}/${src}/hci-mnodecfg"
alias nks="cd ${prefix}/${src}/hci-nks-service"
alias config='/usr/bin/git --git-dir=${HOME}/.cfg --work-tree=${HOME}'
alias sansible=set-ansible
alias h=helm
