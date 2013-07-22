###############################################################
# Global Hooks
###############################################################

# start / stop thin for events web service testing with curl
system "thin start -d -D --chdir '#{RAILS_ROOT}' --port 3002 --adapter rails --environment test --pid '#{RAILS_ROOT}/tmp/pids/thin_curl.pid'"
sleep 2

at_exit do
  # timeout quickly due to thin issue where it doesn't stop gracefully https://thin.lighthouseapp.com/projects/7212/tickets/99
  system "thin stop --chdir '#{RAILS_ROOT}' --pid '#{RAILS_ROOT}/tmp/pids/thin_curl.pid' --timeout 5"
end

###############################################################
# Tagged Hooks
###############################################################

Before('@webservice') do
  @sess = Patron::Session.new
  @sess.timeout = 10
  @sess.insecure = true
  @sess.base_url = "http://localhost:3002"
#  @sess.base_url = "https://vzmm.analytics.smithmicro.com"
end
