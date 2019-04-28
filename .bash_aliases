#!/bin/bash
PLATFORM=$(uname -r)
if [[ ${PLATFORM} == *"Microsoft" ]] ; then
   echo "${STARS} Configuring aliases for WSL"
   prefix="/c/Users/khulques"
   src="OneDrive\ \-\ NetApp\ Inc/src"
   alias docker=docker.exe
   alias 'go'=/c/go/bin/go.exe
else
   echo "${STARS} Configuring aliases for generic Linux"
   prefix="~"
   src="src/projects"
fi

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
alias config='/usr/bin/git --git-dir=/home/khulques/.cfg --work-tree=/home/khulques'
alias sansible=set-ansible
