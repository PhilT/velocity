# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_velocity_session',
  :secret      => '266ae24f0a407012e4bcb1c82ee2f87c1203319ce606c17c478ef6130e26d84c0e801c6029e5fd073ce3768338a492019e8d091e961c4ed1a52674f05b3d6d92'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

