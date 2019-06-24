#!/usr/bin/env bash
# To upload a version of management services
if [ -z ${BINTRAY_USER} ] ; then
   echo "Need to set an environment variable called BINTRAY_USER with the value of your Bintray user id."
   exit 1
fi
if [ -z ${API_KEY} ] ; then
   echo "Need to set an environment variable called API_KEY with the value of your Bintray API key."
   exit 2
fi
echo "* * * INFO: Posting management services $1"
curl -X PUT -T "mnode2_${1}.tar.gz" -u${BINTRAY_USER}:${API_KEY} "https://api.bintray.com/content/netapp-downloads/management-services/upgrade-bundle/${1}/mnode2_${1}.tar.gz?publish=1&explode=0&override=1"
