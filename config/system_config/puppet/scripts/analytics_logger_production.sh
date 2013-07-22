#!/bin/bash
echo "Depricated, please use analytics_bundle instead: 'bash analytics_bundle -i logger -e production'"
# for very verbose output add the --debug flag
/usr/bin/ruby /usr/bin/puppet --verbose ../manifests/analytics_logger_production.pp --modulepath=../modules
