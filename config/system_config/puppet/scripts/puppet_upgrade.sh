#!/bin/bash

# for very verbose output add the --debug flag
/usr/bin/ruby /usr/bin/puppet --verbose ../manifests/puppet_upgrade.pp --modulepath=../modules
