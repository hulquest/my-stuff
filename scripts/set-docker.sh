#!/bin/bash
export PATH=~/bin:$PATH
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
echo "* * * rootless Docker environment set"

