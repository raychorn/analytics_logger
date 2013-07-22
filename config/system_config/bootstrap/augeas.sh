#!/bin/bash

echo "###################"
echo "#      AUGEAS     #"
echo "###################"

# install prerequisites
apt-get -y --force-yes install augeas-lenses libaugeas0 augeas-tools libaugeas-ruby
apt-get -y --force-yes install whois