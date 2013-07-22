node default {
	include analytics_admin::production
	/*Exec { path => "/usr/local/bin:/usr/bin:/bin:/usr/sbin" } 
	require curl # for "common" module, used by tomcat module
	include apache
	
	apache::module {"proxy_ajp":
	    ensure  => present,
	}
	apache::vhost {"analytics_admin":
		ensure => present,
		ports => ['*:9090'],
	}
	apache::listen { "9090": ensure => present }
	apache::namevhost { "*:9090": ensure => present }
	
	# tomcat application server
	$tomcat_version = "7.0.14"
	include tomcat::source # note that the "common" module must exist
	tomcat::instance {"analytics_admin":
	    ensure      => present,
	    ajp_port    => "8000",
	    http_port   => "",
		sample      => true,
	}
	apache::proxypass {"analytics_admin":
	    ensure   => present,
	    location => "/",
	    vhost    => "analytics_admin",
	    url      => "ajp://localhost:8000/sample/",
	}*/
}