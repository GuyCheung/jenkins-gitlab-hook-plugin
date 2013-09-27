require 'jruby/core_ext'
require 'jenkins/rack'

require_relative 'unprotected_root_action'
require_relative 'api'

java_import Java.java.util.logging.Logger

class GitlabWebHookRootAction < Jenkins::Model::UnprotectedRootAction
  include Jenkins::Model::DescribableNative
  include Jenkins::RackSupport

  LOGGER = Logger.getLogger(GitlabWebHookRootAction.class.name)

  display_name "Gitlab Web Hook Rotten"
  icon nil # we don't need the link in the main navigation
  url_path "gitlab"

  attr_reader :conf_param

  #def initialize(attributes = {})
  #  LOGGER.info "=========== GitlabWebHookRootAction INIT ==================="
  #  LOGGER.info attributes.inspect
  #
  #  attributes.each do |k, v|
  #    instance_variable_set "@#{k}", v
  #  end
  #end

  def call(env)
    LOGGER.info "=========== GitlabWebHookRootAction ENV ==================="
    LOGGER.info env.inspect
    GitlabWebHook::Api.new.call(env)
  end

  #java_signature 'boolean configure(StaplerRequest, JSONObject) rotten'
  #def configure(req, json)
  #  LOGGER.info "11 rotten =================================="
  #  LOGGER.info req.inspect
  #  LOGGER.info json.inspect
  #  LOGGER.info "12 rotten =================================="
  #  req.bindJSON(this, json)
  #  LOGGER.info "13 rotten =================================="
  #  save
  #  LOGGER.info "14 rotten =================================="
  #  true
  #end
end

#GitlabWebHookRootAction.add_method_annotation("configure", java.lang.Override => {})

Jenkins::Plugin.instance.register_extension(GitlabWebHookRootAction)
