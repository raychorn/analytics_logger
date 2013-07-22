#!/bin/bash

dir=`dirname "$0"`

myshell=bash

cd "$dir"
rm -rf temp
#$myshell ./hosts.sh
$myshell ./apt.sh
#$myshell ./rubyenterprise.sh
$myshell ./ruby.sh
$myshell ./puppetclient.sh
$myshell ./augeas.sh
