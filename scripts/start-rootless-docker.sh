#!/usr/bin/env bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NONE='\033[0m'
function start_docker {
    OUT=$(systemctl --user start docker)
    if [[ $? == 0 ]] ; then
        printf "* * * ${GREEN}Rootless docker running${NONE}\n"
    else
        printf "* * * ${RED}Failed to start rootless docker ${NONE}\n"
        printf "* * * ${RED}${OUT}${NONE}\n"
        echo "* * * Exiting..."
    fi
}
function check_docker {
    ACTIVE=$(systemctl --user status docker |grep 'active (running)')
    if [[ ! -z ${ACTIVE} ]] ; then
        printf "* * * ${GREEN}Rootless docker running${NONE}\n"
        OUT=$(env |grep DOCKER)
        echo "* * * ${OUT}"
    else
        printf "* * * ${RED}Rootless docker not running${NONE}\n"
        echo "* * * Starting..."
        start_docker
    fi
}
check_docker