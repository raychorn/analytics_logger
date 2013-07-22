#!/bin/bash

echo "###################"
echo "# RUBY ENTERPRISE #"
echo "###################"

# install prerequisites
apt-get -y --force-yes install build-essential zlib1g-dev libssl-dev libreadline5-dev
apt-get -y --force-yes install libopenssl-ruby1.8 libshadow-ruby1.8 ruby

# install Ruby Enterprise Edition
wget http://rubyforge.org/frs/download.php/71096/ruby-enterprise-1.8.7-2010.02.tar.gz
tar xzvf ruby-enterprise-1.8.7-2010.02.tar.gz 
./ruby-enterprise-1.8.7-2010.02/installer --auto=/opt/ruby-enterprise-1.8.7-2010.02

# symlink so REE is in path
ln -sf /opt/ruby-enterprise-1.8.7-2010.02/bin/* /usr/local/bin/
