include Java

java_import Java.hudson.BulkChange
java_import Java.hudson.model.listeners.SaveableListener

java_import Java.java.util.logging.Logger
java_import Java.java.util.logging.Level

class GitlabWebHookRootActionDescriptor < Jenkins::Model::DefaultDescriptor
  LOGGER = Logger.getLogger(GitlabWebHookRootActionDescriptor.class.name)

  attr_reader :conf_param

  def initialize(*)
    super
    load
    LOGGER.info "=========== GitlabWebHookRootActionDescriptor initialize ==================="
    LOGGER.info "conf_param: #{conf_param}"
  end

  def configure(req, form)
    LOGGER.info "=========== GitlabWebHookRootActionDescriptor configure ==================="
    parse(form)
    LOGGER.info "form: #{form.inspect}"
    LOGGER.info "conf_param: #{conf_param}"
    LOGGER.info "getId: #{getId()}"
    LOGGER.info "getConfigFile: #{getConfigFile()}"
    save
    true
  end

  def parse(form)
    @conf_param = form["conf_param"]
  end

  # @see hudson.model.Descriptor#save()
  def save
    return if BulkChange.contains(self)

    begin
      File.open(configFile.file.canonicalPath, 'wb') { |f| f.write(to_xml) }
      SaveableListener.fireOnChange(self, configFile)
    rescue IOError => e
      LOGGER.log(Level::SEVERE, "Failed to save #{configFile}: #{e.message}", e)
    end
  end

  # @see hudson.model.Descriptor#load()
  def load
    return unless configFile.file.exists()
    from_xml(File.read(configFile.file.canonicalPath))
  end

  def to_xml
"<?xml version='1.0' encoding='UTF-8'?>
<#{id} plugin=\"gitlab-hook\">
  <conf_param>#{@conf_param}</conf_param>
</#{id}>"
  end

  def from_xml(xml)
    @conf_param = xml.scan(/<conf_param>(.*)<\/conf_param>/).flatten.first
  end
end
