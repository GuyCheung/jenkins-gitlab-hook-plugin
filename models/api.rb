require 'sinatra/base'

require_relative 'exceptions/bad_request_exception'
require_relative 'exceptions/configuration_exception'
require_relative 'exceptions/not_found_exception'
require_relative 'use_cases/process_commit'
require_relative 'use_cases/process_delete_commit'
require_relative 'services/parse_request'

include Java

java_import Java.java.util.logging.Logger
java_import Java.java.util.logging.Level

module GitlabWebHook
  class Api < Sinatra::Base
    get '/ping' do
      'Gitlab Web Hook is up and running :-)'
    end

    notify_commit = lambda do
      process_projects Proc.new { |project| NotifyCommit.new(project).call }
    end
    get '/notify_commit', &notify_commit
    post '/notify_commit', &notify_commit

    build_now = lambda do
      process_projects Proc.new { |project, details| BuildNow.new(project).with(details) }
    end
    get '/build_now', &build_now
    post '/build_now', &build_now

    private

    def process_projects(action)
      details = parse_request
      messages = details.is_delete_branch_commit? ? ProcessDeleteCommit.new.with(details) : ProcessCommit.new.with(details, action)
      logger.info(messages.join("\n"))
      messages.join("<br/>")
    rescue BadRequestException => e
      logger.warning(e.message)
      status 400
      e.message
    rescue NotFoundException => e
      logger.warning(e.message)
      status 404
      e.message
    rescue => e
      logger.log(Level::SEVERE, e.message, e)
      status 500
      e.message
    end

    def parse_request
      details = ParseRequest.new.from(params, request)
      logger.info("gitlab web hook triggered for repo url #{details.repository_url} and #{details.branch} branch")
      logger.info("with payload: #{details.payload}")
      details
    end

    def logger
      @logger || Logger.getLogger(self.class.name)
    end
  end
end