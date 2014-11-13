require 'open3'

module Capo
  class Deployer
    def self.build params
      branch = params.fetch('branch', nil)
      server = params.fetch('server')
      app = params.fetch('app')
      who = params.fetch('who')
      force = params.fetch('force', false)

      cmd = ''
      cmd << "ALLOW_NO_CHANGE_DEPLOYMENTS=true " if force == 'true'
      cmd << "BRANCH=#{branch} " if branch
      cmd << "cd /home/ubuntu/governor && "
      cmd << "bundle exec cap #{server} "
      cmd << "#{app} " unless branch
      cmd << "deploy"
      run(cmd, who)
    end

    def self.run(cmd, who)
      deployment = Deployment.new(nil, cmd, who, Time.now)
      deployment.start

      Thread.new(deployment) do |deployment|
        build_log = OutputLog.new
        build_log.puts "== Started at : #{Time.now}\n"

        # TODO 10% 50% etc, grep output for key points
        Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
          while line = stdout_err.gets
            build_log.puts line
          end
        end

        deployment.finished

        build_log.puts "== Ended at : #{Time.now}"
      end

      deployment.build_number
    end
  end
end
