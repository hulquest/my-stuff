#!/usr/bin/env bash
# script called by systemd: kevin.service.  
# copy to: /data on host.
mount --bind /data/kevin /home/kevin
