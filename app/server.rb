require 'sinatra/base'

module Capo
  class Server < Sinatra::Base

    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == ENV['CAPO_USERNAME'] && password == ENV['CAPO_PASSWORD']
    end

    get '/' do
      erb :index, locals: { deployments: Deployment.read }
    end

    get '/info' do
      Deployment.read.reverse.first(5).map(&:to_s).join("\n")
    end

    post '/deploy' do
      deploy(params)
    end

    get '/deploy' do
      deploy(params)
    end

    get '/deployment/:number' do |number|
      deployment = Deployment.read(number.to_i)
      log = OutputLog.read(number.to_i)
      if deployment && log
        erb :deployment, locals: { metadata: deployment, log: log }
      else
        redirect '/'
      end
    end

    get '/deployment/:number/log' do |number|
      OutputLog.read(number.to_i)
    end

    get '/delete/:build_number' do |build_number|
      Deployment.delete(build_number.to_i)
      redirect '/'
    end

    get '/*' do
      redirect '/'
    end

    REQUIRED = %w{server who app}
    OPTIONAL = %w{branch force}
    def deploy(params)
      valid = REQUIRED.all? { |p| params.keys.include? p }
      if valid
        id = Deployer.build(params)
        "Started! build:#{id}"
      else
        "Error: required: #{REQUIRED}, optional: #{OPTIONAL}"
      end
    end
  end
end
