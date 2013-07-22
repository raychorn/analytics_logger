#!/bin/bash

echo "#################"
echo "# PUPPET CLIENT #"
echo "#################"

# copy local gems
cp -f ../puppet/modules/rubygems/files/facter-1.6.0.gem ./
cp -f ../puppet/modules/rubygems/files/puppet-2.6.4.gem ./
cp -f ../puppet/modules/rubygems/files/rubygems-update-1.8.10.gem ./

# update gem
/usr/bin/gem1.8 install --local rubygems-update
# update --system will check online (remove)
#/usr/bin/gem1.8 update --system

# install puppet (automatically installs dependencies)
/usr/bin/gem1.8 install --local puppet -v=2.6.4 --no-rdoc --no-ri

# >= 2.6, I think this is only applicable while running on the server on a client-server puppet config
# /usr/bin/puppet agent --mkusers
