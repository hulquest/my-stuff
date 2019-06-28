#!/usr/bin/env bash
# To upload a version of management services
OPTS=`getopt -o vhb: --long verbose,help,build-id: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

eval set -- "$OPTS"

VERBOSE=false
HELP=false
BUILD="0"
REPO="management-services-stg"

while true; do
  case "$1" in
      -v | --verbose ) VERBOSE=true; shift ;;
      -h | --help )    HELP=true; shift ;;
      -b | --build-id ) BUILD="$2"; shift ; shift ;;
      -p | --production ) PROD=true; shift ;;
      -- ) shift; break ;;
      * ) break ;;
  esac
done

if [ ${HELP} == true ] ; then
   echo "$0 [--verbose] [--help] <--build-id 2.1.282> [--production]"
   echo "   Pushes to Bintray Test by default.  Only certain credentials can push to production."
   exit -1
fi

if [ ${VERBOSE} == true ] ; then
    set -x
fi

if [ ${PROD} == true ] ; then
   echo "* * * WARN: Pushing to production."
   REPO="management-services"
fi

if [[ ${BUILD} == "0" ]] ; then
   echo "* * * ERR: Build id is a required parameter.  Form: x.y.nnnn"
   exit 1
else
   echo "* * * INFO: Will download and install build version: ${BUILD}"
   FAT_TAR="mnode2_${BUILD}.tar.gz"
   FAT_TAR_URL="http://sf-artifactory.eng.solidfire.net/artifactory/generic-binary-local/${FAT_TAR}"
   BINTRAY_URL="https://api.bintray.com/content/netapp-downloads/${REPO}/upgrade-bundle/${BUILD}/${FAT_TAR}"
fi

if [ -z ${BINTRAY_USER} ] ; then
   echo "Need to set an environment variable called BINTRAY_USER with the value of your Bintray user id."
   exit 2
fi
if [ -z ${API_KEY} ] ; then
   echo "Need to set an environment variable called API_KEY with the value of your Bintray API key."
   exit 3
fi

# Download
if [ -f ${FAT_TAR} ] ; then
   echo "* * * INFO: ${FAT_TAR} already downloaded."
else
   echo "* * * INFO: Downloading management services ${BUILD}"
   wget -o "download-${BUILD}.log" ${FAT_TAR_URL}
   if [ $? == 0 ] ; then
       echo "* * * INFO: Successful download of management services ${BUILD}"
   else
       echo "* * *  ERR: Failed to download management services ${BUILD}"
       echo "* * *  ERR: Attempted download from URL [${FAT_TAR_URL}]"
       exit 4
   fi
fi

# Install
echo "* * * INFO: Installing management services ${BUILD}"
curl -X PUT -T "${FAT_TAR}" -u${BINTRAY_USER}:${API_KEY} "${BINTRAY_URL}?publish=1&explode=0&override=1"
if [ $? == 0 ] ; then
    echo "* * * INFO: Successful installation of management services ${BUILD}"
    rm ${FAT_TAR}
else
    echo "* * *  ERR: Failed to install management services ${BUILD}"
    exit 5
fi
