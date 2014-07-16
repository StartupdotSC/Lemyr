rails_env = ENV['RAILS_ENV'] || 'development'

listen "unix:tmp/sockets/unicorn.socket", :backlog => 64
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 30
preload_app true
pid "tmp/pids/unicorn.pid"

# Production specific settings
if rails_env == "production"
  working_directory "/home/deploy/apps/lemyr/current"

  user 'deploy', 'deploy'
  shared_path = "/home/deploy/apps/lemyr/shared"

  stderr_path "#{shared_path}/log/unicorn.stderr.log"
  stdout_path "#{shared_path}/log/unicorn.stdout.log"
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server,worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end
