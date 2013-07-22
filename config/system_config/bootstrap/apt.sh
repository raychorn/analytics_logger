#!/bin/bash

echo "#############"
echo "#    APT    #"
echo "#############"

dir=`dirname "$0"`

# copy Package.gz sources to /opt/analytics/packages
# TODO: Check if Debian or Redhat System (or include seperate scripts or flag option)
(mkdir -p /opt/analytics/debian/) || { echo "Using Analytics Packages in Directory /opt/analytics/"; }
cp -rf ../puppet/modules/apt/files/analytics-debian-archives.tar.gz /opt/
tar -xvf /opt/analytics-debian-archives.tar.gz -C /opt/analytics/debian/

sleep 3

# re-write sources.list to include local repository
# TODO: Check if Debian or Redhat System (or include seperate scripts or flag option)
# NOTE: This will overwrite whatever is in sources, however, puppet will write a correct sources file
echo "deb file:///opt/analytics/debian/archives /" > /etc/apt/sources.list
# TODO: Instead of Allowing Unauthenticated, Sign our Local Repo Packages.gz
echo "APT { GET { AllowUnauthenticated \"true\"; }; };" > /etc/apt/apt.conf.d/46analytics

sleep 3

# update system
apt-get update
apt-get -y --force-yes install
apt-get -y --force-yes upgrade
apt-get -y --force-yes install curl
