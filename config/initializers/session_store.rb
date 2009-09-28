# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_WikresLabs_session',
  :secret      => 'd9f6064172b28e649f2d8795825c5364ebef8b3d707c974fbd3f4057f881d505eee811f9353ccbbd0fc74e9d5975703d897ffc6304a92e3e0320ab84cc5b5469'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
