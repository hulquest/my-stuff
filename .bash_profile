#!/bin/bash
if [ -f ${HOME}/.bashrc ] ; then
	source ${HOME}/.bashrc
fi
export GPG_TTY=$(tty)
