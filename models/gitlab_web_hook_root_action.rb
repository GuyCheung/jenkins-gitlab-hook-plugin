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

  display_name "Gitlab Web Hook Rotten"
  icon nil # we don't need the link in the main navigation
  url_path "gitlab"

  describe_as Java.hudson.model.Descriptor, :with => GitlabWebHookRootActionDescriptor

  def call(env)
    logger.info "=========== GitlabWebHookRootAction ENV ==================="
    logger.info "getDescriptor: #{getDescriptor.inspect}"
    logger.info "descriptor_is: #{self.class.descriptor_is.inspect}"
    #logger.info "conf_param: #{self.class.descriptor_is.conf_param}"
    #logger.info "conf_param: #{GitlabWebHookRootActionDescriptor.newInstance.conf_param}"
    logger.info "env: #{env.inspect}"
    GitlabWebHook::Api.new.call(env)
  end

  def logger
    @logger || Logger.getLogger(self.class.name)
  end
end

#class GitlabWebHookRootActionProxy# < Java.hudson.slaves.NodeProperty
#  include Jenkins::Model::EnvironmentProxy
#  include Jenkins::Model::DescribableProxy
#  proxy_for GitlabWebHookRootAction
#end

Jenkins::Plugin.instance.register_extension(GitlabWebHookRootAction)

#class GitlabWebHookRootAction < Jenkins::Model::UnprotectedRootAction
#  include Jenkins::Model
#  #include Jenkins::Model::DescribableNative
#  include Jenkins::Model::Describable
#  include Jenkins::RackSupport
#
#  LOGGER = Logger.getLogger(GitlabWebHookRootAction.class.name)
#
#  display_name "Gitlab Web Hook Rotten"
#  icon nil # we don't need the link in the main navigation
#  url_path "gitlab"
#
#  class TestDescriptor < Java.hudson.model.Descriptor
#    include Jenkins::Model::Descriptor
#
#    def isApplicable(targetType)
#      true
#    end
#  end
#
#  def call(env)
#    LOGGER.info "=========== GitlabWebHookRootAction ENV ==================="
#    LOGGER.info "getDescriptor: #{getDescriptor.inspect}"
#    LOGGER.info "descriptor_is: #{self.class.descriptor_is.inspect}"
#    #LOGGER.info "conf_param: #{self.class.descriptor_is.conf_param}"
#    LOGGER.info "conf_param: #{GitlabWebHookRootActionDescriptor.newInstance.conf_param}"
#    LOGGER.info "env: #{env.inspect}"
#    GitlabWebHook::Api.new.call(env)
#  end
#
#  #describe_as Java.hudson.model.Descriptor, :with => GitlabWebHookRootActionDescriptor
#  describe_as Java.hudson.model.Descriptor, :with => TestDescriptor
#end
