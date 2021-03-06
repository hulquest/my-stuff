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
   alias kind=kind.exe
else
   # echo "${STARS} Configuring aliases for generic Linux"
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

function astra-version {
    cd ${HOME}/src/projects/polaris
    ./cicd/scripts/get_latest_version_tag.sh --version-only $1
    cd -
}

alias lr='ls -ltr'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gv=gvim
alias pip3=/usr/bin/pip3
alias src="cd ${prefix}/${src}"
alias po="cd ${prefix}/${src}/polaris"
alias op="cd ${prefix}/${src}/polaris/acc-operator"
alias config='/usr/bin/git --git-dir=${HOME}/.cfg --work-tree=${HOME}'
alias sansible=set-ansible
alias h=helm
alias mk=minikube
alias k=kubectl
alias tf=terraform
alias nv=nvim
alias vi=nvim
alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
alias watch='watch '
alias av=astra-version
