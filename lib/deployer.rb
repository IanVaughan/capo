require 'open3'

class Deployer
  def self.build params
    branch = params.fetch('branch', nil)
    server = params.fetch('server')
    app = params.fetch('app')
    who = params.fetch('who')
    force = params.fetch('force', false)

    cmd = ''
    cmd << "cd /home/ubuntu/governor && "
    cmd << "GIT_AUTHOR_NAME=#{who} " # for capistrano notification
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
    DeplomentWorker.perform_async(deployment.build_number, cmd)
    deployment.build_number
  end
end
