require 'jenkins/rack'

require_relative 'api'
require_relative 'unprotected_root_action'
require_relative 'gitlab_web_hook_root_action_descriptor'

include Java

java_import Java.java.util.logging.Logger

class GitlabWebHookRootAction < Jenkins::Model::UnprotectedRootAction
  include Jenkins::Model
  include Jenkins::Model::DescribableNative
  include Jenkins::RackSupport

  LOGGER = Logger.getLogger(GitlabWebHookRootAction.class.name)

  display_name "Gitlab Web Hook Rotten"
  icon nil # we don't need the link in the main navigation
  url_path "gitlab"

  attr_accessor :conf_param

  def call(env)
    LOGGER.info "=========== GitlabWebHookRootAction ENV ==================="
    LOGGER.info conf_param
    LOGGER.info getDescriptor.inspect
    LOGGER.info env.inspect
    GitlabWebHook::Api.new.call(env)
  end

  describe_as Java.hudson.model.Descriptor, :with => GitlabWebHookRootActionDescriptor
end

Jenkins::Plugin.instance.register_extension(GitlabWebHookRootAction)
