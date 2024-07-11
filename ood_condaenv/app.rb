require 'bundler'
require './command'
require '/share/support/public/ood/ruby/hostspecs.rb'
Bundler.require

module ClusterNodeStatus

    class App < Sinatra::Base

        # global settings
        configure do
            set :root, File.dirname(__FILE__)
            set :public_folder, 'public'

            register Sinatra::ActiveRecordExtension
        end

        # require all models
        Dir.glob('./lib/*.rb') do |model|
            require model
        end

        # root route
        get '/'  do 
            @command = Command.new
            @conda_env_table, @error = @command.exec

            erb :index
        end

	helpers do
            def dashboard_title
		getHostSpecs()[:host]+" OnDemand"
            end

            def dashboard_url
                "/pun/sys/dashboard/"
            end

            def title
                "Update Conda environments in OOD"
            end
        end
    end

end
