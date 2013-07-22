# the server where migrations are run from (we don't want to run ruby on db.mxplay.com)
set :repository, "https://build@mmeng.smithmicro.net/repos/main/analytics/trunk/analytics_logger"
set :use_sudo, false
set(:deploy_to) { "/var/www/analytics_logger/#{application}" }
set :user, "deploy"
set :deploy_via, :remote_cache
set :copy_exclude, [".svn"]
set :keep_releases, 2 # for deploy:cleanup
default_run_options[:pty] = true

# use the 'local' task for running tests against your own machine (e.g. a VM running locally)
task :local do
  set :application, "analytics_local"
  set :analytics1, "analytics.local"
  role :app, analytics1
  role :web, analytics1
  set :analytics_load_balancer, "analytics.local"
  set :analytics_sudo_user, "cloud"
  set :analytics_port, 80
  set :analytics_secure_port, 443
  set :analytics_admin_port, 8080
  set :analytics_secure_admin_port, 8443
  set :analytics_site_template, "_template.conf"
  set :analytics_deploy_puppet, false
  set :analytics_puppet_manifest, "analytics_server_production.pp"
  # set :rabbitmq_host, "localhost"
  set :rabbitmq_host, "analytics.local"
  set :rabbitmq_routing_key, "testRoute"
end

task :dev do
  set :application, "dev"
  set :dev1, "dev1.analytics.smithmicro.net"
  set :dev2, "dev2.analytics.smithmicro.net"
  role :app, dev1, dev2
  role :web, dev1, dev2
  set :analytics_load_balancer, "dev.analytics.smithmicro.net" # used in Apache config for ServerName
  set :analytics_sudo_user, "cftuser"
  set :analytics_port, 80
  set :analytics_secure_port, 443
  set :analytics_admin_port, 8080
  set :analytics_secure_admin_port, 8443
  set :analytics_site_template, "_template_ssl.conf"
  set :analytics_deploy_puppet, false
  set :analytics_puppet_manifest, "analytics_logger_dev.pp"
  set :rabbitmq_host, "10.100.162.51"
  set :rabbitmq_routing_key, "testRoute"
end

#task :qa do
#  set :application, "bakrie"
#  set :dev1, "10.100.162.71"
#  set :dev2, "10.100.162.72"
#  role :app, dev1, dev2
#  role :web, dev1, dev2
#  set :analytics_load_balancer, "qa.analytics.smithmicro.net" # used in Apache config for ServerName
#  set :analytics_sudo_user, "cloud"
#  set :analytics_port, 80
#  set :analytics_secure_port, 443
#  set :analytics_admin_port, 8080
#  set :analytics_secure_admin_port, 8443
#  set :analytics_site_template, "_template.conf"
#  set :analytics_deploy_puppet, false
#  set :analytics_puppet_manifest, "analytics_logger_production.pp"
#  set :rabbitmq_host, "hive1"
#  set :rabbitmq_routing_key, "testRoute"
#end

#task :staging do
#  set :application, "staging"
#  set :analytics1, "analytics1.smithmicro.com"
#  set :analytics2, "analytics2.smithmicro.com"
#  role :app, analytics1, analytics2
#  role :web, analytics1, analytics2
#  set :analytics_load_balancer, "staging.analytics.smithmicro.net"
#  set :analytics_sudo_user, "cloud"
#  set :analytics_port, 80
#  set :analytics_secure_port, 443
#  set :analytics_admin_port, 8080
#  set :analytics_secure_admin_port, 8443
#  set :analytics_site_template, "_template.conf"
#  set :analytics_deploy_puppet, false # temporarily disabled since puppet is broken for Ubuntu 8.04
#  set :analytics_puppet_manifest, "analytics_logger_production.pp"
#  set :rabbitmq_host, "10.100.162.61"
#  set :rabbitmq_routing_key, "testRoute"
#end


task :bakrie do
  set :application, "bakrie"
  set :analytics1, "analytics1.smithmicro.com"
  set :analytics2, "analytics2.smithmicro.com"
  role :app, analytics1
  role :web, analytics1
  set :analytics_load_balancer, "staging.analytics.smithmicro.net"
  set :analytics_sudo_user, "cloud"
  set :analytics_port, 80
  set :analytics_secure_port, 443
  set :analytics_admin_port, 8080
  set :analytics_secure_admin_port, 8443
  set :analytics_site_template, "_template.conf"
  set :analytics_deploy_puppet, false # temporarily disabled since puppet is broken for Ubuntu 8.04
  set :analytics_puppet_manifest, "analytics_server_production.pp"
  set :rabbitmq_host, "10.100.162.61"
  set :rabbitmq_routing_key, "testRoute"
end

task :videodev do
  set :application, "videodev"
  set :dev1, "192.168.62.4"
  role :app, dev1
  role :web, dev1
  set :analytics_sudo_user, "cloud"
  set :analytics_port, 80
  set :analytics_secure_port, 443
  set :analytics_admin_port, 8080
  set :analytics_secure_admin_port, 8443
  set :analytics_site_template, "_template.conf"
  set :analytics_deploy_puppet, false
  set :analytics_puppet_manifest, "analytics_logger_dev.pp"
  set :rabbitmq_host, "10.100.162.51"
  set :rabbitmq_routing_key, "testRoute"
end

#task :testproduction do
#  set :application, "test"
##  set :analytics1, "analytics1.smithmicro.com"
#  set :analytics2, "analytics2.smithmicro.com"
#  role :app, analytics2
#  role :web, analytics2
#  set :analytics_load_balancer, "test.analytics.smithmicro.com"
#  set :analytics_sudo_user, "cloud"
#  set :analytics_port, 89
#  set :analytics_secure_port, 452
#  set :analytics_admin_port, 8089
#  set :analytics_secure_admin_port, 8449
#  set :analytics_site_template, "_template.conf"
#  set :analytics_deploy_puppet, false
#  set :analytics_puppet_manifest, "analytics_logger_production.pp"
#  set :rabbitmq_host, "10.100.162.61"
#  set :rabbitmq_routing_key, "testRoute"
#end

#task :vzmmdev do
#  set :application, "vzmm"
#  set :dev1, "dev1.analytics.smithmicro.net"
#  set :dev2, "dev2.analytics.smithmicro.net"
#  role :app, dev1, dev2
#  role :web, dev1, dev2
#  set :analytics_load_balancer, "vzmmdev.analytics.smithmicro.net"
#  set :analytics_sudo_user, "cftuser"
#  set :analytics_port, 81
#  set :analytics_secure_port, 444
#  set :analytics_admin_port, 8081
#  set :analytics_secure_admin_port, 8444
#  set :analytics_site_template, "_template.conf"
#  set :analytics_deploy_puppet, false
#  set :analytics_puppet_manifest, "analytics_logger_dev.pp"
#  set :rabbitmq_host, "10.100.162.51"
#  set :rabbitmq_routing_key, "testRoute"
#end

#task :vzmmproduction do
#  set :application, "vzmm"
#  set :analytics1, "analytics1.smithmicro.com"
#  set :analytics2, "analytics2.smithmicro.com"
#  role :app, analytics1, analytics2
#  role :web, analytics1, analytics2
#  set :analytics_load_balancer, "vzmm.analytics.smithmicro.com"
#  set :analytics_sudo_user, "cloud"
#  set :analytics_port, 81
#  set :analytics_secure_port, 444
#  set :analytics_admin_port, 8081
#  set :analytics_secure_admin_port, 8444
#  set :analytics_site_template, "_template.conf"
#  set :analytics_deploy_puppet, false
#  set :analytics_puppet_manifest, "analytics_logger_production.pp"
#  set :rabbitmq_host, "10.100.162.61"
#  set :rabbitmq_routing_key, "testRoute"
#end

task :qlm8sdev do
  set :application, "qlm8s"
  set :dev1, "dev1.analytics.smithmicro.net"
  set :dev2, "dev2.analytics.smithmicro.net"
  role :app, dev1, dev2
  role :web, dev1, dev2
  set :analytics_load_balancer, "qlm8s.analytics.smithmicro.net"
  set :analytics_sudo_user, "cftuser"
  set :analytics_port, 83
  set :analytics_secure_port, 446
  set :analytics_admin_port, 8083
  set :analytics_secure_admin_port, 8446
  set :analytics_site_template, "_template.conf"
  set :analytics_deploy_puppet, false
  set :analytics_puppet_manifest, "analytics_logger_dev.pp"
  set :rabbitmq_host, "10.100.162.51"
  set :rabbitmq_routing_key, "qlm8sRoute"
end

task :vttdev do
  set :application, "vtt"
  set :dev1, "dev1.analytics.smithmicro.net"
  set :dev2, "dev2.analytics.smithmicro.net"
  role :app, dev1, dev2
  role :web, dev1, dev2
  set :analytics_load_balancer, "vttdev.analytics.smithmicro.net"
  set :analytics_sudo_user, "cftuser"
  set :analytics_port, 84
  set :analytics_secure_port, 447
  set :analytics_admin_port, 8084
  set :analytics_secure_admin_port, 8447
  set :analytics_site_template, "_template.conf"
  set :analytics_deploy_puppet, false
  set :analytics_puppet_manifest, "analytics_logger_dev.pp"
  set :rabbitmq_host, "10.100.162.51"
  set :rabbitmq_routing_key, "testRoute"
end

task :dev1_1 do
  set :application, "dev1_1"
  set :dev1, "dev1.analytics.smithmicro.net"
  set :dev2, "dev2.analytics.smithmicro.net"
  role :app, dev1, dev2
  role :web, dev1, dev2
  set :analytics_load_balancer, "dev1_1.analytics.smithmicro.net"
  set :analytics_sudo_user, "cftuser"
  set :analytics_port, 85
  set :analytics_secure_port, 446
  set :analytics_admin_port, 8085
  set :analytics_secure_admin_port, 8446
  set :analytics_site_template, "_template.conf"
  set :analytics_deploy_puppet, false
  set :analytics_puppet_manifest, "analytics_logger_dev.pp"
  set :rabbitmq_host, "10.100.162.51"
  set :rabbitmq_routing_key, "dev1_1Route"
end

after "deploy", "deploy:cleanup"
after "deploy:update_code", "puppet:upgrade", "puppet:deploy", "rabbitmq:config", "gems:install"

namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    with_user(analytics_sudo_user) do
      # Need to use {current_release} instead of {current_path} because the "current"
      # symlink hasn't been updated yet when "update_code" task runs.
      run "cd #{current_release} && sudo rake gems:install RAILS_ENV='production'"
      # HACK: fix ownership of log files from root to deploy user since rake gem:install task generates log files whose owner is root
      run "sudo chown -R deploy:www-data #{deploy_to}/shared/log"
    end
  end
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :rabbitmq do
  task :config, :roles => :app do
    local_repo_template_path = "config/sites/rabbitmq/rabbitmq_config.yml"
    remote_repo_config_path = "#{current_release}/config/rabbitmq_config.yml"
    
    logger.info "generating rabbitmq_config.yml from template"
    result = process_template(local_repo_template_path)
    put(result, remote_repo_config_path, :via => :scp, :mode => 0644)       
  end
end

namespace :apache do
  desc "update apache per-app conf files, uploading local copies"
  task :update, :roles => :app do
    local_repo_config_path = "config/sites/apache2/sites-available/#{application}.conf"
    local_repo_template_path = "config/sites/apache2/sites-available/#{analytics_site_template}"
    remote_repo_config_folder = "#{deploy_to}/current/config/sites/apache2/sites-available"
    remote_repo_config_path = "#{remote_repo_config_folder}/#{application}.conf"

    logger.info "generating from template"
    result = process_template(local_repo_template_path)
    run "mkdir -p #{remote_repo_config_folder}"
    put(result, remote_repo_config_path, :via => :scp, :mode => 0644)   

    with_user(analytics_sudo_user) do
      run "sudo rm -rf /etc/apache2/sites-enabled/#{application}.conf"
      run "sudo cp #{remote_repo_config_path} /etc/apache2/sites-available/#{application}.conf"
      run "sudo ln -s ../sites-available/#{application}.conf /etc/apache2/sites-enabled/#{application}.conf"
    end
  end

  desc "update apache root conf files, uploading local copies"
  task :update_root_conf, :roles => :app do
    upload("config/sites/apache2/ports.conf", "#{deploy_to}/current/config/sites/apache2/ports.conf", :via => :scp)
    upload("config/sites/apache2/mods-available/passenger.conf", "#{deploy_to}/current/config/sites/apache2/mods-available/passenger.conf", :via => :scp)

    with_user(analytics_sudo_user) do
      run "sudo cp #{deploy_to}/current/config/sites/apache2/ports.conf /etc/apache2/ports.conf"
      run "sudo cp #{deploy_to}/current/config/sites/apache2/mods-available/passenger.conf /etc/apache2/mods-available/passenger.conf"
      run "sudo rm -rf /etc/apache2/mods-enabled/passenger.conf"
      run "sudo ln -s ../mods-available/passenger.conf /etc/apache2/mods-enabled/passenger.conf"
    end
  end

  %w(start stop restart).each do |action|
    desc "#{action} Apache"
    task action.to_sym, :roles => :app do
      with_user(analytics_sudo_user) do
        run "sudo apache2ctl #{action}"
      end
    end
  end
end

namespace :puppet do
  desc "invoke puppet standalone"
  task :upgrade, :roles => :app do
    if exists?(:analytics_deploy_puppet) && analytics_deploy_puppet
      with_user(analytics_sudo_user) do
        run "cd #{current_release}/config/system_config/puppet && sudo /usr/bin/ruby /usr/bin/puppet -v manifests/puppet_upgrade.pp --modulepath=modules"
      end
    end  
  end
  task :deploy, :roles => :app do
    if exists?(:analytics_deploy_puppet) && analytics_deploy_puppet
      with_user(analytics_sudo_user) do
        run "cd #{current_release}/config/system_config/puppet && sudo /usr/bin/ruby /usr/bin/puppet -v manifests/#{analytics_puppet_manifest} --modulepath=modules"
      end
    else
      logger.info "puppet:deploy not invoked since :analytics_deploy_puppet not set to true"  
    end
  end
end

# TODO: should take in a password or clear password
def with_user(new_user, &block)
  old_user = user
  set :user, new_user
  close_sessions
  yield
  set :user, old_user
  close_sessions
end

def close_sessions
  sessions.values.each { |session| session.close }
  sessions.clear
end

def process_template(file_path)
    f = File.new(file_path)
    template = f.read
    # escape double quotes
    template = template.gsub('"','\"')
    return eval( '"' + template + '"' )
end
