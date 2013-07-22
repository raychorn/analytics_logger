#!/bin/bash

echo "###################"
echo "#       RUBY      #"
echo "###################"

# install prerequisites
apt-get -y --force-yes install build-essential zlib1g-dev libssl-dev libreadline5-dev

# install ruby
apt-get -y --force-yes install ruby1.8-dev libreadline-ruby1.8 libruby1.8 libopenssl-ruby1.8 libshadow-ruby1.8 ruby ri rdoc irb

# install rubygems
# wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
#tar zxvf rubygems-1.3.7.tgz
tar zxvf ../puppet/modules/rubygems/files/rubygems-1.3.7.tgz -C ./
cd rubygems-1.3.7
/usr/bin/ruby setup.rb
ln -sf gem1.8 /usr/bin/gem
