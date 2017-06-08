Resque.after_fork do
  ActiveRecord::Base.clear_active_connections!
  ActiveRecord::Base.establish_connection
end

WORKER_CONCURRENCY = Integer(ENV["WORKER_CONCURRENCY"] || 5)