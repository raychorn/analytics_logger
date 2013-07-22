node default {
	Exec { path => 
	"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" }
	#MySQL needs to be present before any Database or Rights can be modified.
	#There's a bug where they get bypassed if mysqladmin is not installed.
	include augeas # for mysql
	include pwgen # for mysql
	include mysql::server::medium
	include mysql::client
}