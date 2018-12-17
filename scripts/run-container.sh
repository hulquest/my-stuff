#!/usr/bin/env bash
source py35-sfp/bin/activate
bin/get_docker_image.py
docker run --rm -it -v ~/src/projects/sfprime/system_test:/sfprime-auto/ -v ~/.ssh:/root/.ssh docker.sqd.solidfire.net:9000/sfprime-auto:latest
