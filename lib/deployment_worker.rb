class DeplomentWorker
  include Sidekiq::Worker

  def perform(build_number, cmd)
    deployment = Deployment.read(build_number)

    build_log = OutputLog.new
    build_log.puts "\n== Started at : #{Time.now}\n"

    Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
      while line = stdout_err.gets
        build_log.puts line
      end
    end

    build_log.puts "\n== Script finished with exit code:#{$?.exitstatus}"
    build_log.puts "\n== Ended at : #{Time.now}"
  end
end
