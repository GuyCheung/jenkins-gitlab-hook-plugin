require 'jruby/core_ext'
require 'jenkins/rack'

require_relative 'unprotected_root_action'
require_relative 'api'

java_import Java.java.util.logging.Logger

class GitlabWebHookRootAction < Jenkins::Model::UnprotectedRootAction
  include Jenkins::Model::DescribableNative
  include Jenkins::RackSupport

  LOGGER = Logger.getLogger(GitlabWebHookRootAction.class.name)

  display_name "Gitlab Web Hook"
  icon nil # we don't need the link in the main navigation
  url_path "gitlab"

  attr_accessor :conf_param

  #def initialize(attributes = [])
    #LOGGER.info "=========== GitlabWebHookRootAction ==================="
    #LOGGER.info attributes.inspect
  #end

  def call(env)
    GitlabWebHook::Api.new.call(env)
  end

  java_signature 'boolean configure(StaplerRequest, JSONObject)'
  def configure(req, json)
    LOGGER.info "11 =================================="
    LOGGER.info req.inspect
    LOGGER.info json.inspect
    LOGGER.info "12 =================================="
    req.bindJSON(this, json)
    LOGGER.info "13 =================================="
    save
    LOGGER.info "14 =================================="
    true
  end

end

GitlabWebHookRootAction.add_method_annotation("configure", java.lang.Override => {})

#Jenkins::Plugin.instance.register_extension(GitlabWebHookRootAction.new)
Jenkins::Plugin.instance.register_extension(GitlabWebHookRootAction)
