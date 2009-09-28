set :application, "wikres_labs"
set :user, "wikresco"
set :domain, "#{user}@box324.bluehost.com"
set :repository,  "#{domain}:/home/#{user}/rails_apps/#{application}"
set :local_repository, "."

default_run_options[:pty] = true
set :scm_command, "/home/#{user}/bin/git"
set :use_sudo, false

# If you have previously been relying upon the code to start, stop
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/#{user}/rails_apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
# see a full list by running "gem contents capistrano | grep 'scm/'"

role :web, domain
role :app, domain
role :db, domain, :primary => true