# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_analytics_logger_session',
  :secret      => 'a411038a3d8ba749523473e7acdc6f052d610c09b23279e93db3621ebf8fa592fd7df47271c9456da5e664b624c03e7d933749ae41a87d76a64fc9225a4a9659'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
