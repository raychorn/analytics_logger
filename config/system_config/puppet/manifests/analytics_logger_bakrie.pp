node default {
	include analytics_logger::production::bakrie
	/*Exec { path => "/usr/local/bin:/usr/bin:/bin:/usr/sbin" } 
	require virt_users::production, virt_groups::production
	include apache
	
	# Should find a way to make this dynamic
	# probably just add more classes for each.
	$logger_deployment = "bakrie"
	$logger_version = "trunk"
	$rabbitmq_host = "hive1"
	$rabbitmq_routing_key = "testRoute"
	
	file { "/var/www/analytics_logger":
		require => [ User['deploy'], Group['deploy'], Class['apache'] ],
		mode => 775,
		owner => "deploy",
		group => "deploy",
		ensure => directory,
		recurse => false, # because 'www' is created by apache, owned by root
	}
	
	# apache
	apache::module {"proxy_http":
	    ensure  => present,
	}
	apache::module {"headers":
	    ensure  => present,
	}
	apache::module {"expires":
	    ensure  => present,
	}
	apache::vhost {$logger_deployment:
		ensure => present,
		ports => ['*:80'],
		aliases => ['bakrie.analytics.smithmicro.net'],
		enable_default => false,
		docroot => "/var/www/analytics_logger/$logger_deployment/current/public",
		docdir_ops => ['Options -Indexes +FollowSymLinks', 'AllowOverride None', 'Order allow,deny', 'Allow from all'],
		location_deny => "/admin",
		passenger => true,
	}
	apache::vhost {"$logger_deployment-admin":
		ensure => present,
		ports => ['*:8080'],
		aliases => ['$logger_deployment.analytics.smithmicro.net'],
		enable_default => false,
		docroot => "/var/www/analytics_logger/$logger_deployment/current/public",
		docdir_ops => ['Options -Indexes +FollowSymLinks', 'AllowOverride None', 'Order allow,deny', 'Allow from all'],
		passenger => true,
	}
	apache::listen { "8080": ensure => present }
	
	# dependencies
	class { ruby_enterprise: version => "1.8.7-2011.03" }
	class { rails: version => "2.3.11" }
	class { passenger: version => "2.2.15" }
	
	# deploy logger
	file { "/opt/analytics-logger-$logger_version.tar.gz":
		owner => deploy,
		group => deploy,
		source => "puppet:///modules/analytics_logger/analytics-logger-$logger_version.tar.gz"
	}
	
	common::archive::extract {"analytics-logger-$logger_version":
		ensure => present,
		src_target => "/opt",
		target => "/var/www/analytics_logger/$logger_deployment/current/",
		require => File["/opt/analytics-logger-$logger_version.tar.gz"]
	}
	# might want to change owner a different way, archive::extract doesn't use owner
	file {[
			"/var/www/analytics_logger/$logger_deployment/",
			"/var/www/analytics_logger/$logger_deployment/current/",
			"/var/www/analytics_logger/$logger_deployment/current/app",
			"/var/www/analytics_logger/$logger_deployment/current/config",
			"/var/www/analytics_logger/$logger_deployment/current/db",
			"/var/www/analytics_logger/$logger_deployment/current/doc",
			"/var/www/analytics_logger/$logger_deployment/current/features",
			"/var/www/analytics_logger/$logger_deployment/current/lib",
			"/var/www/analytics_logger/$logger_deployment/current/log",
			"/var/www/analytics_logger/$logger_deployment/current/public",
			"/var/www/analytics_logger/$logger_deployment/current/script",
			"/var/www/analytics_logger/$logger_deployment/current/spec",
			"/var/www/analytics_logger/$logger_deployment/current/test",
			"/var/www/analytics_logger/$logger_deployment/current/tmp",
			"/var/www/analytics_logger/$logger_deployment/current/vendor",
		]:
		owner => "deploy",
		group => "deploy",
		ensure => directory,
	}
	# hack
	exec { "chown -R deploy:deploy /var/www/analytics_logger/$logger_deployment/": require => Common::Archive::Extract["analytics-logger-$logger_version"] }
	
	# rabbitmq config
	file { "/var/www/analytics_logger/$logger_deployment/current/config/rabbitmq_config.yml":
		owner => deploy,
		group => deploy,
		require => Exec["chown -R deploy:deploy /var/www/analytics_logger/$logger_deployment/"],
		content => template("analytics_logger/rabbitmq_config.yml.erb"),
	}
	
	# gems (might want to add them to vendor folder in package)
	exec {"logrotate":
		require => Exec["symlink_ruby_enterprise_source"],
		command => "gem install logrotate",
	}
	exec {"colinsurprenant-qpid":
		command   => "gem install colinsurprenant-qpid -s http://gems.github.com",
		require => Exec["symlink_ruby_enterprise_source"],
	}
	*/
}
