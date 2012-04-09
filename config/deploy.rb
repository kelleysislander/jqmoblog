=begin

For a first time deploy or to blow away the data tables and repopulate from seeds.rb:

"cap deploy:setup"

Thereafter:

"cap staging deploy"

then "cap staging deploy:migrations" on the local

OR

"RAILS_ENV=staging bundle exec rake db:setup" on the remote server


In case you need to run "cap deploy:setup" again and you don’t want Capistrano to ask for a database password, 
set the skip_db_setup option to true. This is especially useful in combination with capistrano multi-stage 
recipe when you already setup your server and you share the same environment across all the stages.

$ cap deploy:setup -s "skip_db_setup=true"

after that do a "cap deploy:cold" (does migrations) and when that is good do a:

rake db:setup

=end

set :stages, %w(staging production beaglebone)
set :default_stage, "staging"

require 'bundler/capistrano'

require 'capistrano/ext/multistage'

puts "ENV['rvm_path']"
puts "rvm_path => #{ENV['rvm_path']}"
puts "END ENV['rvm_path']"

puts ENV['rails_env']

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))  # Add RVM's lib directory to the load path.

require "rvm/capistrano"                                # Load RVM's capistrano plugin.

set :rvm_ruby_string, '1.9.2-p290@jqmoblog'               # Or whatever env you want it to run in.

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'deploy')

set :rvm_bin_path, "$HOME/.rvm/bin"
set :rvm_type, :user

puts "******************* deploy.rb: require capistrano_database **********************"

require "capistrano_database"

# namespace :db do
#   desc 'Migrate DB down, up, seed'
#   # run like: cap staging deploy db:seed
#   task :seed do
#     run "rake db:seed"
#   end
# end

namespace :deploy do

  desc "Restarting mod_rails with restart.txt, capistrano runs this by default"
  task :restart, :roles => :app, :except => { :no_release => true } do
    puts "************ running => task :restart, :roles => :app, :except => { :no_release => true }"
    run "touch #{current_path}/tmp/restart.txt"
  end

  # NOTE: you must manually create the "#{shared_path}/config/" dir since capistrano does not create a "config" dir for you
  # unless you already ran "cap deploy:setup" which would have created the dir and put the database.yml into it
  
  desc 'moves the current .rvmrc into #{shared_path/config/.rvmrc and symlinks it'
  namespace :rvmrc do
    task :symlink, :except => { :no_release => true } do
      puts "************ running: deploy.rb: symlinking .rvmrc: ln -nfs #{shared_path}/config/.rvmrc #{release_path}/config/.rvmrc"
      run "mv -vf #{release_path}/.rvmrc #{shared_path}/config/.rvmrc"
      puts "************ running: ln -nfs #{shared_path}/config/.rvmrc #{release_path}/.rvmrc"
      # run "ln -nfs .rvmrc #{shared_path}/config/.rvmrc"
      run "ln -nfs #{shared_path}/config/.rvmrc #{release_path}/.rvmrc"
    end
  end
  
  
end # namespace :deploy do

after "deploy:symlink",       "deploy:rvmrc:symlink"

=begin
  http://merbist.com/2011/08/30/deploying-a-rails-3-1-app-gotchas/ has some good advice on deploying
=end