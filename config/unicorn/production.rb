app_dir = File.expand_path("../../../",__FILE__)
working_directory app_dir

pid "#{app_dir}/tmp/unicorn.pid"

stderr_path "#{app_dir}/log/unicorn.log"
stdout_path "#{app_dir}/log/unicorn.log"

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 30
preload_app true

listen '/tmp/unicorn.sock', backlog: 64

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(app_dir, 'Gemfile')
end