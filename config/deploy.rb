set :application, "velocity"
set :repository,  "git://github.com/PhilT/velocity.git"

set :scm, :git
set :branch, 'master'

set :user, 'ubuntu'
set :deploy_to, nil

set :use_sudo, true
set :keep_releases, 3

set :target_env, 'production'

set :ssh_options, {:forward_agent => true}
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "default.key")]

after 'deploy', 'deploy:cleanup'

role :web, "velocity.puresolo.com"                          # Your HTTP server, Apache/etc
role :app, "velocity.puresolo.com"                          # This may be the same as your `Web` server
role :db,  "velocity.puresolo.com", :primary => true # This is where Rails migrations will run

after "deploy:update_code", "gems:install"
after "deploy:update_code", "copy_db_config"

before "deploy", "check_env"

task :check_env do
  unless deploy_to
    puts "Think again!"
    exit
  end
end

task :velocity do
  set :deploy_to, '/data/velocity'
end

task :todo do
  set :deploy_to, '/data/todo'
end

namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{current_release} && #{sudo} rake gems:install"
  end
end

task :copy_db_config do
  run "cp #{deploy_to}/shared/database.yml #{current_release}/config/database.yml"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
