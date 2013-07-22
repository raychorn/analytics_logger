# nodes.pp
#
# Note: Should later be used with puppetmaster for individual hosts
#       currently running in standalone.
#

node base {
	$user="hadoop"
	$group="hadoop"
}

node base_dev inherits base {  
	require virt_users::dev, virt_groups::dev
  $cluster_name = "dev"
  $hadoop_version = "0.20"
  $hadoop_namenode_dir = "/var/lib/hadoop/cache/hdfs/dfs/name/"
  $hadoop_default_fs_name = "hivedevlocal:51210"
  $hadoop_datastore = "/hadoop-a/dfs/data"
  $mapred_job_tracker = "hivedevlocal:51211"
  $mapred_local_dir = "/hadoop-a/mapred"
  $environment="dev"
  $hadoop_home="/home/hadoop/hadoop"
  $hadoop_from_source = false
  $hbase_home="/home/hadoop/hbase"
  $hbase_from_source = false
  $zookeeper_home="/home/hadoop/zookeeper"
  $zookeeper_from_source = false
  $java_home_dir = "/usr/lib/jvm/java-6-sun"
  $hadoop_heap_size = "500"
}

node base_bakrie inherits base {  
	require virt_users::production, virt_groups::production
  $cluster_name = "bakrie"
  $hadoop_version = "0.20"
  $hadoop_namenode_dir = "/var/lib/hadoop/cache/hdfs/dfs/name/"
  $hadoop_default_fs_name = "hive1:61210"
  $hadoop_datastore = "/hadoop-a/dfs/data, /hadoop-b/dfs/data, /hadoop-c/dfs/data"
  $mapred_job_tracker = "hive1:61211"
  $mapred_local_dir = "/hadoop-a/mapred,/hadoop-b/mapred,/hadoop-c/mapred"
  $environment="production"
  $hadoop_home="/home/hadoop/hadoop"
  $hadoop_from_source = false
  $hbase_home="/home/hadoop/hbase"
  $hbase_from_source = false
  $zookeeper_home="/home/hadoop/zookeeper"
  $zookeeper_from_source = false
  $java_home_dir = "/usr/lib/jvm/java-6-sun"
  $hadoop_heap_size = "4000"
}

node base_trial inherits base {  
	require virt_users::production, virt_groups::production
  # Overwritten by Facts in /etc/analytics/ & hadoop_volumes (fdisk/df)
  $cluster_name = $analytics_cluster_name
  $hadoop_version = "0.20"
  $hadoop_namenode_dir = "/var/lib/hadoop/cache/hdfs/dfs/name/"
  $hadoop_default_fs_name = $analytics_hadoop_default_fs_name
  $hadoop_datastore = $hadoop_volumes_dfs
  $mapred_job_tracker = $analytics_mapred_job_tracker
  $mapred_local_dir = $hadoop_volumes_mapred
  $environment="production"
  $hadoop_home="/home/hadoop/hadoop"
  $hadoop_from_source = false
  $hbase_home="/home/hadoop/hbase"
  $hbase_from_source = false
  $zookeeper_home="/home/hadoop/zookeeper"
  $zookeeper_from_source = false
  $java_home_dir = "/usr/lib/jvm/java-6-sun"
  $hadoop_heap_size = $analytics_hadoop_heap_size
}

node base_production inherits base {  
	require virt_users::production, virt_groups::production
  $cluster_name = $analytics_cluster_name
  $hadoop_version = "0.20"
  $hadoop_namenode_dir = "/var/lib/hadoop/cache/hdfs/dfs/name/"
  $hadoop_default_fs_name = $analytics_hadoop_default_fs_name
  $hadoop_datastore = $hadoop_volumes_dfs
  $mapred_job_tracker = $analytics_mapred_job_tracker
  $mapred_local_dir = $hadoop_volumes_mapred
  $mapred_child_ops = $analytics_hadoop_child_opts
  $environment="production"
  $hadoop_home="/home/hadoop/hadoop"
  $hadoop_from_source = false
  $hbase_home="/home/hadoop/hbase"
  $hbase_from_source = false
  $zookeeper_home="/home/hadoop/zookeeper"
  $zookeeper_from_source = false
  $java_home_dir = "/usr/lib/jvm/java-6-sun"
  $hadoop_heap_size = $analytics_hadoop_heap_size
}

# The Following Nodes require a Master/Client Setup, not currently in use:
node "hivedev1" inherits base_dev { }
node "hivedev2" inherits base_dev { }
node "dev1" inherits base_dev { }
node "dev2" inherits base_dev { }