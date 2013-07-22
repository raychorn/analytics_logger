#!/bin/bash
###################################################################################
# analytics_bundle.sh
#
# This scripts initiates Puppet for Analytics Bundle.
# Bundle: Hadoop, High Availability, Hive, Hbase, Zookeeper, Mon
#
##################################################################################
#
##################################################################################

usage()
{
cat << EOF
	usage: $0 [arguments] [options]
	example: $0 -i masternode -e dev

	This script builds smsi hadoop.
	
	ARGUMENTS:
	  -i		install/deploy - (masternode, slavenode, datanode, tasknode, logger, admin, portal) [Required]
	  -r		revert/uninstall - WARNING! This will Revert the installation and also Remove any Data!

	OPTIONS:
	  -h		Show this message
	  -u		Allow for upgrades
	  -f		Force Install - Bypasses all Interaction (Non-Interactive Install)
	  -e		Environment - (dev [default], trial, production)
	
	ADVANCED OPTIONS:
	  /etc/analytics/	- Java .properties files corresponding to each install may be placed here to override internal options.
	  					- Example Files: admin.properties, logger.properties, bundle.properties
						- Variables: port=xxxx
EOF
}
#Check the number of arguments and exit if it's wrong
if [ $# -lt 1 ]
then
	usage
	exit 1
fi

function pause(){
   read -p "$*"
}

INSTALL=FALSE
UPGRADE=FALSE
ENV=dev
REVERT=FALSE
SKIPSETTINGS=FALSE
while getopts "hfrui:e:" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
		 i)
		     INSTALL=$OPTARG
		     ;;
		 u)
		     UPGRADE="TRUE"
		     ;;		
		 e)
		     ENV=$OPTARG	
		     ;;
		 r)	
	     	 REVERT="TRUE"	
	     	 ;;
		 f)
		 	 SKIPSETTINGS="TRUE"
		 	 ;;
         ?)
             usage
             exit
             ;;
     esac
done

# Check for Settings File
SETTINGS=FALSE
(mkdir -p /etc/analytics) || { echo "Using Analytics Settings Directory /etc/analytics/"; SETTINGS=TRUE; }
if [ $SETTINGS != "FALSE" ]
then
	if [ $SKIPSETTINGS != "TRUE" ]
	then
		read -p "Overwrite /etc/analytics with Installation Settings?' (y/[n])?"
		[ "$REPLY" == "y" ] && (cp ../config/* /etc/analytics/) || { echo "using default analytics properties..."; }
		[ "$REPLY" != "y" ] && echo "using default analytics properties in /etc/analytics/..."
	fi
else
	if [ $SKIPSETTINGS != "TRUE" ]
	then
		(cp ../config/* /etc/analytics/) || { echo "using default analytics properties..."; }
	fi
fi

if [ $UPGRADE != "FALSE" ]
then
	echo "analytics_upgrade=true" > /etc/analytics/upgrade.properties
else
	echo "analytics_upgrade=false" > /etc/analytics/upgrade.properties
fi

if [ $INSTALL != "FALSE" ]
then
	if [ $SKIPSETTINGS != "TRUE" ]
	then
		read -p "Customize default settings (you can always re-run this installer with new settings)?' (y/[n])?"
		if [ "$REPLY" == "y" ] 
		then
			case "$INSTALL" in
			'masternode'|'slavenode'|'datanode'|'tasknode')
				echo "The following settings will be applied to: 'masternode','slavenode','datanode','tasknode' installations on $HOSTNAME."
				read -p "Cluster/Customer Name?' [default]: "
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/admin.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/logger.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/portal.properties) || { echo "using default value!"; }
				read -p "Analytics Hive Name Host:Port?' [hive1:41210]: "
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_hadoop_default_fs_name=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				read -p "Analytics Hive Filesystem Host:Port?' [hive1:41211]: "
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_mapred_job_tracker=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				read -p "Analytics System Heap Size?' [4000]: "
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_hadoop_heap_size=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				read -p "Analytics Hadoop Child Opts?' [-Xmx1024M]: "
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_hadoop_child_opts=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				read -p "Parallel Expanders Allowed?' [12]: "
				[ "$REPLY" != "" ] && (echo "parallel_processes=${REPLY}" > /etc/analytics/expander.properties) || { echo "using default value!"; }
			;;
			'logger')
				echo "The following settings will be applied to: 'logger' installations on $HOSTNAME."
                                read -p "Cluster/Customer Name?' [default]: "
                                [ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/admin.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/logger.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/portal.properties) || { echo "using default value!"; }
				read -p "Logger 'POST' Port Number?' [80]: "
				[ "$REPLY" != "" ] && (sed -e "1i\logger_port_post=${REPLY}" -i /etc/analytics/logger.properties) || { echo "using default value!"; }
				read -p "Logger 'Admin' Port Number?' [8080]: "
				[ "$REPLY" != "" ] && (sed -e "1i\logger_port_admin=${REPLY}" -i /etc/analytics/logger.properties) || { echo "using default value!"; }
				read -p "Rabbitmq Master Host?' [hive1]: "
				[ "$REPLY" != "" ] && (sed -e "1i\rabbitmq_master_host=${REPLY}" -i /etc/analytics/logger.properties) || { echo "using default value!"; }
			;;
			'admin')
				echo "The following settings will be applied to: 'admin' installations on $HOSTNAME."
                                read -p "Cluster/Customer Name?' [default]: "
                                [ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/admin.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/logger.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/portal.properties) || { echo "using default value!"; }
				read -p "Admin Port Number?' [3001]: "
				[ "$REPLY" != "" ] && (sed -e "1i\admin_apache_port=${REPLY}" -i /etc/analytics/admin.properties) || { echo "using default value!"; }
				read -p "Admin Tomcat 'ajp' Port Number?' [8000]: "
				[ "$REPLY" != "" ] && (sed -e "1i\admin_apache_ajp_port=${REPLY}" -i /etc/analytics/admin.properties) || { echo "using default value!"; }
				read -p "Admin Tomcat OPTS?' [-Xms1024m -Xmx2048m]: "
				[ "$REPLY" != "" ] && (sed -e "1i\admin_catalina_opts=${REPLY}" -i /etc/analytics/admin.properties) || { echo "using default value!"; }
			;;
			'portal')
				echo "The following settings will be applied to: 'portal' installations on $HOSTNAME."
                                read -p "Cluster/Customer Name?' [default]: "
                                [ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/bundle.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/admin.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/logger.properties) || { echo "using default value!"; }
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_cluster_name=${REPLY}" -i /etc/analytics/portal.properties) || { echo "using default value!"; }
				read -p "Portal Port Number?' [80]: "
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_portal_port=${REPLY}" -i /etc/analytics/portal.properties) || { echo "using default value!"; }
				read -p "Portal Fully Qualified Domain?' [localhost]: "
				[ "$REPLY" != "" ] && (sed -e "1i\analytics_portal_domain=${REPLY}" -i /etc/analytics/portal.properties) || { echo "using default value!"; }
			;;
			esac
			# TODO: Maybe separate by INSTALL type.
		fi
	fi
	echo "### Initiating Puppet: analytics_bundle::${ENV}::${INSTALL}"
	# for very verbose output add the --debug flag
	(/usr/bin/ruby /usr/bin/puppet --verbose ../manifests/mysql_init.pp --modulepath=../modules) || { echo "Error Installing MySQL."; usage; exit 1; }
	(/usr/bin/ruby /usr/bin/puppet --verbose ../manifests/analytics_${INSTALL}_${ENV}.pp --modulepath=../modules) || { echo "Install Environment or Type does not exist."; usage; exit 1; }
fi

if [ $REVERT == "TRUE" ]
then
	echo "### Uninstalling Analytics...you have 10 seconds to change your mind..."
	sleep 10
	pause 'Press any key to continue...'
	echo "this process will delete all the data on this node, this is the last warning!"
	sleep 5
	echo "5"
	sleep 1
	echo "4"
	sleep 1
	echo "3"
	sleep 1
	echo "2"
	sleep 1
	echo "1"
	sleep 1
	echo "..."
	/etc/init.d/hadoop-0.20-tasktracker stop
	/etc/init.d/hadoop-0.20-jobtracker stop
	/etc/init.d/hadoop-0.20-datanode stop
	/etc/init.d/hadoop-0.20-secondarynamenode stop
	/etc/init.d/hadoop-0.20-namenode stop
	sleep 2
	rm -rf /hadoop-*/*
	rm -rf /var/lib/hadoop/cache/hdfs/dfs/name
	rm -rf /etc/hadoop-*/
	echo "You might want to delete the hadoop-* packages manually."
	echo "## Analytics Uninstall Completed!"
fi
