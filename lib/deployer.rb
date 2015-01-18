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
      cmd << "cd /home/ubuntu/governor && "
      cmd << "GIT_AUTHOR_NAME=#{who} " # for capistrano slack notification
      cmd << "USER=#{who} " # for capistrano_deploy_lock
      cmd << "ALLOW_NO_CHANGE_DEPLOYMENTS=true " if force == 'true'
      cmd << "BRANCH=#{branch} " if branch
      cmd << "bundle exec cap #{server} "
      cmd << "#{app} " unless branch
      cmd << "deploy"

      pretty_cmd = ''
      pretty_cmd << "BRANCH=#{branch} " if branch
      pretty_cmd << "#{server} "
      pretty_cmd << "#{app} " unless branch
      pretty_cmd << "forced " if force == 'true'

      run(cmd, who, pretty_cmd)
    end

    def self.run(cmd, who, pretty_cmd)
      deployment = Deployment.new(nil, pretty_cmd, who, Time.now)
      deployment.start

      Thread.new(deployment) do |deployment|
        build_log = OutputLog.new
        build_log.puts "\n== Started at : #{Time.now}\n"

        # TODO 10% 50% etc, grep output for key points
        Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
          while line = stdout_err.gets
            build_log.puts line
          end
        end

        deployment.finished

        build_log.puts "\n== Ended at : #{Time.now}"
      end

      deployment.build_number
    end
  end
end
