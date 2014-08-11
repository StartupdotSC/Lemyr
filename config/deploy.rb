# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'lemyr'
set :repo_url, 'git@github.com:CubicPhase/Lemyr.git'

set :deploy_to, '/home/deploy/apps/lemyr'

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :keep_releases, 5

# Rbenv Config
set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'
set :rbenv_map_bins, %w{rake gem bundle ruby rails foreman}

# Rollbar Config
set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

# Unicorn Config
set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end

  after :finishing, 'deploy:cleanup'
end
