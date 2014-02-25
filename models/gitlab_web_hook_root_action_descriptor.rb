include Java

java_import Java.hudson.BulkChange
java_import Java.hudson.model.listeners.SaveableListener

java_import Java.java.util.logging.Logger
java_import Java.java.util.logging.Level

class GitlabWebHookRootActionDescriptor < Jenkins::Model::DefaultDescriptor
  attr_accessor :conf_param

  def initialize(*)
    logger.info "=========== GitlabWebHookRootActionDescriptor initialize ==================="
    super
    load
    logger.info "conf_param: #{conf_param}"
  end

  def configure(req, form)
    logger.info "=========== GitlabWebHookRootActionDescriptor configure ==================="
    parse(form)
    logger.info "conf_param: #{conf_param}"
    logger.info "form: #{form.inspect}"
    logger.info "getId: #{getId()}"
    logger.info "getConfigFile: #{getConfigFile()}"
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
      logger.log(Level::SEVERE, "Failed to save #{configFile}: #{e.message}", e)
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

  #def newInstance(request, form)
  #  super
  #  logger.info "=========== GitlabWebHookRootActionDescriptor newInstance ==================="
  #  logger.info request.inspect
  #  logger.info form.inspect
  #end

  def logger
    @logger || Logger.getLogger(self.class.name)
  end
end

#class GitlabWebHookRootActionDescriptor < Jenkins::Model::DefaultDescriptor
#  attr_reader :conf_param
#
#  def configure(req, form)
#    req.bindJSON(self, form)
#    save
#    true
#  end
#end

=begin
Listening for transport dt_socket at address: 8000
Running from: /home/elvanja/.rbenv/versions/jruby-1.6.7/lib/ruby/gems/1.8/gems/jenkins-war-1.475/lib/jenkins/jenkins.war
webroot: System.getProperty("JENKINS_HOME")
Oct 01, 2013 2:11:08 PM winstone.Logger logInternal
INFO: Beginning extraction from war file
Jenkins home directory: /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/work found at: System.getProperty("JENKINS_HOME")
Oct 01, 2013 2:11:09 PM winstone.Logger logInternal
INFO: HTTP Listener started: port=8080
Oct 01, 2013 2:11:09 PM winstone.Logger logInternal
INFO: Winstone Servlet Engine v0.9.10 running: controlPort=disabled
Oct 01, 2013 2:11:09 PM jenkins.InitReactorRunner$1 onAttained
INFO: Started initialization
Oct 01, 2013 2:11:11 PM hudson.ClassicPluginStrategy createPluginWrapper
INFO: Plugin cvs.jpi is disabled
Oct 01, 2013 2:11:12 PM hudson.PluginManager$1$3$1 isDuplicate
INFO: Ignoring /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/work/plugins/git.hpi because /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/work/plugins/git.jpi is already loaded
Oct 01, 2013 2:11:12 PM jenkins.InitReactorRunner$1 onAttained
INFO: Listed all plugins
Oct 01, 2013 2:11:12 PM ruby.RubyRuntimePlugin start
INFO: Injecting JRuby into XStream
Trying to load models from /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/gitlab_web_hook_root_action.rb
file:/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/work/plugins/ruby-runtime/WEB-INF/lib/jruby-complete-1.7.3.jar!/jruby/java/core_ext/object.rb:73 warning: already initialized constant Logger
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/api.rb
/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/api.rb:18 warning: already initialized constant LOGGER
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/gitlab_web_hook_root_action_descriptor.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/unprotected_root_action.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/use_cases/process_delete_commit.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/use_cases/build_now.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/use_cases/create_project_for_branch.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/use_cases/notify_commit.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/use_cases/process_commit.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/exceptions/not_found_exception.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/exceptions/bad_request_exception.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/exceptions/configuration_exception.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/services/get_jenkins_projects.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/services/parse_request.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/services/get_build_actions.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/services/get_build_cause.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/parameters_request_details.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/project.rb
/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/project.rb:29 warning: already initialized constant LOGGER
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/repository_uri.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/request_details.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/payload_request_details.rb
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/settings.rb
/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/settings.rb:8 warning: already initialized constant CREATE_PROJECTS_FOR_NON_MASTER_BRANCHES_AUTOMATICALLY
/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/settings.rb:9 warning: already initialized constant MASTER_BRANCH
/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/settings.rb:10 warning: already initialized constant USE_MASTER_PROJECT_NAME
/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/settings.rb:11 warning: already initialized constant DESCRIPTION
/home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/settings.rb:12 warning: already initialized constant ANY_BRANCH_PATTERN
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/models/values/commit.rb
Oct 01, 2013 2:11:20 PM org.jvnet.hudson.plugins.m2release.M2ReleaseBuildWrapper$DescriptorImpl <clinit>
                                                                                    INFO: Using new style Permission with PermissionScope
Trying to load models from /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/work/plugins/rvm/WEB-INF/classes/models
Loading /home/elvanja/infobip/projects/jenkins/gitlab-hook-plugin/work/plugins/rvm/WEB-INF/classes/models/rvm_wrapper.rb
Oct 01, 2013 2:11:21 PM jenkins.InitReactorRunner$1 onAttained
INFO: Prepared all plugins
Oct 01, 2013 2:11:22 PM jenkins.InitReactorRunner$1 onAttained
INFO: Started all plugins
Oct 01, 2013 2:11:22 PM jenkins.InitReactorRunner$1 onAttained
INFO: Augmented all extensions
Oct 01, 2013 2:11:24 PM hudson.ExtensionFinder$GuiceFinder$SezpozModule configure
WARNING: Failed to load org.jvnet.hudson.plugins.m2release.dashboard.RecentReleasesPortlet$DescriptorImpl
java.lang.LinkageError: Failed to resolve class org.jvnet.hudson.plugins.m2release.dashboard.RecentReleasesPortlet$DescriptorImpl
    at hudson.ExtensionFinder$GuiceFinder$SezpozModule.resolve(ExtensionFinder.java:491)
    at hudson.ExtensionFinder$GuiceFinder$SezpozModule.configure(ExtensionFinder.java:524)
    at com.google.inject.AbstractModule.configure(AbstractModule.java:62)
    at com.google.inject.spi.Elements$RecordingBinder.install(Elements.java:230)
    at com.google.inject.spi.Elements.getElements(Elements.java:103)
    at com.google.inject.internal.InjectorShell$Builder.build(InjectorShell.java:136)
    at com.google.inject.internal.InternalInjectorCreator.build(InternalInjectorCreator.java:104)
    at com.google.inject.Guice.createInjector(Guice.java:96)
    at com.google.inject.Guice.createInjector(Guice.java:73)
    at hudson.ExtensionFinder$GuiceFinder.<init>(ExtensionFinder.java:282)
    at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
    at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:57)
    at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
    at java.lang.reflect.Constructor.newInstance(Constructor.java:526)
    at java.lang.Class.newInstance(Class.java:374)
    at net.java.sezpoz.IndexItem.instance(IndexItem.java:181)
    at hudson.ExtensionFinder$Sezpoz._find(ExtensionFinder.java:642)
    at hudson.ExtensionFinder$Sezpoz.find(ExtensionFinder.java:617)
    at hudson.ExtensionFinder._find(ExtensionFinder.java:151)
    at hudson.ClassicPluginStrategy.findComponents(ClassicPluginStrategy.java:316)
    at hudson.ExtensionList.load(ExtensionList.java:295)
    at hudson.ExtensionList.ensureLoaded(ExtensionList.java:248)
    at hudson.ExtensionList.iterator(ExtensionList.java:138)
    at hudson.ClassicPluginStrategy.findComponents(ClassicPluginStrategy.java:309)
    at hudson.ExtensionList.load(ExtensionList.java:295)
    at hudson.ExtensionList.ensureLoaded(ExtensionList.java:248)
    at hudson.ExtensionList.get(ExtensionList.java:153)
    at hudson.PluginManager$PluginUpdateMonitor.getInstance(PluginManager.java:1109)
    at hudson.maven.PluginImpl.init(PluginImpl.java:54)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke(Method.java:606)
    at hudson.init.InitializerFinder.invoke(InitializerFinder.java:120)
    at hudson.init.InitializerFinder$TaskImpl.run(InitializerFinder.java:184)
    at org.jvnet.hudson.reactor.Reactor.runTask(Reactor.java:259)
    at jenkins.model.Jenkins$7.runTask(Jenkins.java:895)
    at org.jvnet.hudson.reactor.Reactor$2.run(Reactor.java:187)
    at org.jvnet.hudson.reactor.Reactor$Node.run(Reactor.java:94)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
    at java.lang.Thread.run(Thread.java:724)
    Caused by: java.lang.TypeNotPresentException: Type hudson.plugins.view.dashboard.DashboardPortlet not present
    at sun.reflect.generics.factory.CoreReflectionFactory.makeNamedType(CoreReflectionFactory.java:117)
    at sun.reflect.generics.visitor.Reifier.visitClassTypeSignature(Reifier.java:125)
    at sun.reflect.generics.tree.ClassTypeSignature.accept(ClassTypeSignature.java:49)
    at sun.reflect.generics.visitor.Reifier.reifyTypeArguments(Reifier.java:68)
    at sun.reflect.generics.visitor.Reifier.visitClassTypeSignature(Reifier.java:138)
    at sun.reflect.generics.tree.ClassTypeSignature.accept(ClassTypeSignature.java:49)
    at sun.reflect.generics.repository.ClassRepository.getSuperclass(ClassRepository.java:84)
    at java.lang.Class.getGenericSuperclass(Class.java:696)
    at hudson.ExtensionFinder$GuiceFinder$SezpozModule.resolve(ExtensionFinder.java:478)
    ... 41 more
    Caused by: java.lang.ClassNotFoundException: hudson.plugins.view.dashboard.DashboardPortlet
    at org.apache.tools.ant.AntClassLoader.findClassInComponents(AntClassLoader.java:1365)
    at org.apache.tools.ant.AntClassLoader.findClass(AntClassLoader.java:1315)
    at org.apache.tools.ant.AntClassLoader.loadClass(AntClassLoader.java:1068)
    at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
    at java.lang.Class.forName0(Native Method)
    at java.lang.Class.forName(Class.java:270)
    at sun.reflect.generics.factory.CoreReflectionFactory.makeNamedType(CoreReflectionFactory.java:114)
    ... 49 more

    Oct 01, 2013 2:11:26 PM jenkins.InitReactorRunner$1 onAttained
    INFO: Loaded all jobs
    Oct 01, 2013 2:11:27 PM org.jenkinsci.main.modules.sshd.SSHD start
    INFO: Started SSHD at port 60884
    Oct 01, 2013 2:11:27 PM jenkins.InitReactorRunner$1 onAttained
    INFO: Completed initialization
    Oct 01, 2013 2:11:28 PM org.springframework.web.context.support.StaticWebApplicationContext prepareRefresh
    INFO: Refreshing org.springframework.web.context.support.StaticWebApplicationContext@f19cca2: display name [Root WebApplicationContext]; startup date [Tue Oct 01 14:11:28 CEST 2013]; root of context hierarchy
    Oct 01, 2013 2:11:28 PM org.springframework.web.context.support.StaticWebApplicationContext obtainFreshBeanFactory
    INFO: Bean factory for application context [org.springframework.web.context.support.StaticWebApplicationContext@f19cca2]: org.springframework.beans.factory.support.DefaultListableBeanFactory@23e15ee2
        Oct 01, 2013 2:11:28 PM org.springframework.beans.factory.support.DefaultListableBeanFactory preInstantiateSingletons
        INFO: Pre-instantiating singletons in org.springframework.beans.factory.support.DefaultListableBeanFactory@23e15ee2: defining beans [authenticationManager]; root of factory hierarchy
        Oct 01, 2013 2:11:28 PM org.springframework.web.context.support.StaticWebApplicationContext prepareRefresh
        INFO: Refreshing org.springframework.web.context.support.StaticWebApplicationContext@51edb4c9: display name [Root WebApplicationContext]; startup date [Tue Oct 01 14:11:28 CEST 2013]; root of context hierarchy
        Oct 01, 2013 2:11:28 PM org.springframework.web.context.support.StaticWebApplicationContext obtainFreshBeanFactory
        INFO: Bean factory for application context [org.springframework.web.context.support.StaticWebApplicationContext@51edb4c9]: org.springframework.beans.factory.support.DefaultListableBeanFactory@7efb0559
            Oct 01, 2013 2:11:28 PM org.springframework.beans.factory.support.DefaultListableBeanFactory preInstantiateSingletons
            INFO: Pre-instantiating singletons in org.springframework.beans.factory.support.DefaultListableBeanFactory@7efb0559: defining beans [filter,legacy]; root of factory hierarchy
            Oct 01, 2013 2:11:28 PM hudson.TcpSlaveAgentListener <init>
                                        INFO: JNLP slave agent listener started on TCP port 55001
            Oct 01, 2013 2:11:28 PM hudson.WebAppMain$3 run
            INFO: Jenkins is fully up and running
            Oct 01, 2013 2:12:07 PM org.jruby.javasupport.JavaMethod invokeDirectWithExceptionHandling
            INFO: =========== GitlabWebHookRootAction ENV ===================
                Oct 01, 2013 2:12:07 PM org.jruby.javasupport.JavaMethod invokeDirectWithExceptionHandling
            INFO: null
            Oct 01, 2013 2:12:07 PM org.jruby.javasupport.JavaMethod invokeDirectWithExceptionHandling
            INFO: nil
            Oct 01, 2013 2:12:07 PM org.jruby.javasupport.JavaMethod invokeDirectWithExceptionHandling
            INFO: {"org.kohsuke.stapler.EvaluationTrace"=>#<Java::OrgKohsukeStapler::EvaluationTrace:0x7f54d8bb>, "__acegi_session_integration_filter_applied"=>true, "org.kohsuke.stapler.compression.CompressionFilter"=>true, "rack.version"=>[1, 1], "rack.input"=>#<JRuby::Rack::Input:0x68120b50>, "rack.errors"=>#<JRuby::Rack::ServletLog:0x78a4e690 @context=#<Java::OrgJrubyRackServlet::DefaultServletRackContext:0x58b8cf2f>>, "rack.url_scheme"=>"http", "rack.multithread"=>true, "rack.multiprocess"=>false, "rack.run_once"=>false, "java.servlet_request"=>#<Java::OrgKohsukeStapler::RequestImpl:0x750d4339>, "java.servlet_response"=>#<Java::OrgKohsukeStapler::ResponseImpl:0x1b375ce6>, "java.servlet_context"=>#<Java::OrgJrubyRackServlet::DefaultServletRackContext:0x58b8cf2f>, "jruby.rack.version"=>"1.1.13.1", "jruby.rack.jruby.version"=>"1.7.3", "jruby.rack.rack.release"=>"1.4", "PATH_INFO"=>"/ping", "QUERY_STRING"=>"", "REMOTE_ADDR"=>"127.0.0.1", "REMOTE_HOST"=>"127.0.0.1", "REMOTE_USER"=>"", "REQUEST_METHOD"=>"GET", "REQUEST_URI"=>"/gitlab/ping?", "SCRIPT_NAME"=>"", "SERVER_NAME"=>"localhost", "SERVER_PORT"=>"8080", "SERVER_SOFTWARE"=>"Winstone Servlet Engine v0.9.10", "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.5", "HTTP_COOKIE"=>"iconSize=24x24; ACEGI_SECURITY_HASHED_REMEMBER_ME_COOKIE=dnJhZG92YW5vdmljOjEzODE0ODI0NjUzMzM6MWE4ZDZjYmRmODFlMTE4MjdmMjIxMzk5ZTE5MWQwY2ZmYWIwMjUwMGZiMmM1NmNkOWZmMDhhNTBlNjZiZmYxOQ==; JSESSIONID.680ee5d3=1d45109da04b7aa685e933a9fb6e27a2; JSESSIONID.efb5f8ab=c90c13b6b5b3511c87d402cd9c1e0e6b; JSESSIONID.22096d51=4795aa9a6a40a62105111e0f71ad21b6; JSESSIONID.29db48cd=256741d639fb582b300608c42de617ed; JSESSIONID.f39c1f4f=2c376241af5a24095ff14ff5d3441fc6; JSESSIONID.5166e305=09c6638ff04fcf331e545d7df9c0e9d2; JSESSIONID.107966fc=fd8dfeefc35e89549dc9922f80be9475; JSESSIONID.d5b9dc0c=7abac2f559c59d3c77f0d56ce19f7a94; JSESSIONID.37006068=2449e0823c5417a644c13b7e92575869; JSESSIONID.f988e7f9=e6b2cf6173c17f4aeb4419707a49d179; JSESSIONID.9fea0df3=95103b7ee32b4c8c0c5ab595ed246c8f; JSESSIONID.7ce643a6=11a78d000239957aaf8752dc56047bbd; JSESSIONID.d08e2767=af658b083b8ad99ec851c33e4cb79440; JSESSIONID.7d2485b6=0985af33ad4b82da573164c2153a7d13; JSESSIONID.8309d7a2=f7752ccc671b1fed83ab4980cbd8c4c1; JSESSIONID.19af3685=4ed4aa6ad537fbdd98a3c38ac4ef2546; JSESSIONID.c16f9c70=9aece5f4f77685880610e52e75a57307; JSESSIONID.7e7061e5=33cc7ac2614f7e48db7e05975ab8fa4f; JSESSIONID.f0def261=6429547b118783da80fc306168b5cc9c; JSESSIONID.1679fee6=de8e86384a6bf63068210f87efa4f469; JSESSIONID.3bf4ee19=ed23b4883002e3a8fe971d092c5cee4a; JSESSIONID.6d6d7d7e=2919898e3d7feaab6f6a667aad75a971; JSESSIONID.742373f6=e7afb40b4177e3caafd4ac54e51b36a6; JSESSIONID.cffe2585=11518ae76902eed74fc35ad5a2304eb0; JSESSIONID.8931f611=fe2974f3f4a788341e84d311c011176d; JSESSIONID.3685f9bb=5c75683271a205a0b9a1953414df6e58; JSESSIONID.63b59a3c=4402fef280018085f50444710a92a33c", "HTTP_HOST"=>"localhost:8080", "HTTP_ACCEPT_ENCODING"=>"gzip, deflate", "HTTP_USER_AGENT"=>"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0", "HTTP_CONNECTION"=>"keep-alive", "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "HTTP_CACHE_CONTROL"=>"max-age=0"}
                       Oct 01, 2013 2:12:26 PM winstone.Logger logInternal
            SEVERE: Error while serving http://localhost:8080/configSubmit
            java.lang.reflect.InvocationTargetException
            at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
            at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
            at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
            at java.lang.reflect.Method.invoke(Method.java:606)
            at org.kohsuke.stapler.Function$InstanceFunction.invoke(Function.java:297)
            at org.kohsuke.stapler.Function.bindAndInvoke(Function.java:160)
            at org.kohsuke.stapler.Function.bindAndInvokeAndServeResponse(Function.java:95)
            at org.kohsuke.stapler.MetaClass$1.doDispatch(MetaClass.java:111)
            at org.kohsuke.stapler.NameBasedDispatcher.dispatch(NameBasedDispatcher.java:53)
            at org.kohsuke.stapler.Stapler.tryInvoke(Stapler.java:685)
            at org.kohsuke.stapler.Stapler.invoke(Stapler.java:799)
            at org.kohsuke.stapler.Stapler.invoke(Stapler.java:587)
            at org.kohsuke.stapler.Stapler.service(Stapler.java:218)
            at javax.servlet.http.HttpServlet.service(HttpServlet.java:45)
            at winstone.ServletConfiguration.execute(ServletConfiguration.java:248)
            at winstone.RequestDispatcher.forward(RequestDispatcher.java:333)
            at winstone.RequestDispatcher.doFilter(RequestDispatcher.java:376)
            at hudson.util.PluginServletFilter$1.doFilter(PluginServletFilter.java:96)
            at hudson.util.PluginServletFilter.doFilter(PluginServletFilter.java:88)
            at winstone.FilterConfiguration.execute(FilterConfiguration.java:194)
            at winstone.RequestDispatcher.doFilter(RequestDispatcher.java:366)
            at hudson.security.csrf.CrumbFilter.doFilter(CrumbFilter.java:48)
            at winstone.FilterConfiguration.execute(FilterConfiguration.java:194)
            at winstone.RequestDispatcher.doFilter(RequestDispatcher.java:366)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:84)
            at hudson.security.UnwrapSecurityExceptionFilter.doFilter(UnwrapSecurityExceptionFilter.java:51)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at jenkins.security.ExceptionTranslationFilter.doFilter(ExceptionTranslationFilter.java:117)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at org.acegisecurity.providers.anonymous.AnonymousProcessingFilter.doFilter(AnonymousProcessingFilter.java:125)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at org.acegisecurity.ui.rememberme.RememberMeProcessingFilter.doFilter(RememberMeProcessingFilter.java:142)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at org.acegisecurity.ui.AbstractProcessingFilter.doFilter(AbstractProcessingFilter.java:271)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at org.acegisecurity.ui.basicauth.BasicProcessingFilter.doFilter(BasicProcessingFilter.java:174)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at jenkins.security.ApiTokenFilter.doFilter(ApiTokenFilter.java:64)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at org.acegisecurity.context.HttpSessionContextIntegrationFilter.doFilter(HttpSessionContextIntegrationFilter.java:249)
            at hudson.security.HttpSessionContextIntegrationFilter2.doFilter(HttpSessionContextIntegrationFilter2.java:67)
            at hudson.security.ChainedServletFilter$1.doFilter(ChainedServletFilter.java:87)
            at hudson.security.ChainedServletFilter.doFilter(ChainedServletFilter.java:76)
            at hudson.security.HudsonFilter.doFilter(HudsonFilter.java:164)
            at winstone.FilterConfiguration.execute(FilterConfiguration.java:194)
            at winstone.RequestDispatcher.doFilter(RequestDispatcher.java:366)
            at org.kohsuke.stapler.compression.CompressionFilter.doFilter(CompressionFilter.java:46)
            at winstone.FilterConfiguration.execute(FilterConfiguration.java:194)
            at winstone.RequestDispatcher.doFilter(RequestDispatcher.java:366)
            at hudson.util.CharacterEncodingFilter.doFilter(CharacterEncodingFilter.java:81)
            at winstone.FilterConfiguration.execute(FilterConfiguration.java:194)
            at winstone.RequestDispatcher.doFilter(RequestDispatcher.java:366)
            at winstone.RequestDispatcher.forward(RequestDispatcher.java:331)
            at winstone.RequestHandlerThread.processRequest(RequestHandlerThread.java:227)
            at winstone.RequestHandlerThread.run(RequestHandlerThread.java:150)
            at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:471)
            at java.util.concurrent.FutureTask$Sync.innerRun(FutureTask.java:334)
            at java.util.concurrent.FutureTask.run(FutureTask.java:166)
            at winstone.BoundedExecutorService$1.run(BoundedExecutorService.java:77)
            at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
            at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
            at java.lang.Thread.run(Thread.java:724)
            Caused by: java.lang.RuntimeException: Failed to serialize org.jruby.proxy.hudson.model.Descriptor$Proxy0#__handler for class org.jruby.proxy.hudson.model.Descriptor$Proxy0
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.TreeMarshaller.start(TreeMarshaller.java:82)
            at com.thoughtworks.xstream.core.AbstractTreeMarshallingStrategy.marshal(AbstractTreeMarshallingStrategy.java:37)
            at com.thoughtworks.xstream.XStream.marshal(XStream.java:898)
            at com.thoughtworks.xstream.XStream.marshal(XStream.java:887)
            at com.thoughtworks.xstream.XStream.toXML(XStream.java:860)
            at hudson.XmlFile.write(XmlFile.java:183)
            at hudson.model.Descriptor.save(Descriptor.java:758)
            at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
            at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
            at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
            at java.lang.reflect.Method.invoke(Method.java:606)
            at org.jruby.javasupport.JavaMethod.invokeDirectWithExceptionHandling(JavaMethod.java:440)
            at org.jruby.javasupport.JavaMethod.tryProxyInvocation(JavaMethod.java:621)
            at org.jruby.javasupport.JavaMethod.invokeDirect(JavaMethod.java:301)
            at org.jruby.java.invokers.InstanceMethodInvoker.call(InstanceMethodInvoker.java:52)
            at org.jruby.runtime.callsite.CachingCallSite.cacheAndCall(CachingCallSite.java:306)
            at org.jruby.runtime.callsite.CachingCallSite.call(CachingCallSite.java:136)
            at org.jruby.ast.VCallNode.interpret(VCallNode.java:88)
            at org.jruby.ast.NewlineNode.interpret(NewlineNode.java:105)
            at org.jruby.ast.BlockNode.interpret(BlockNode.java:71)
            at org.jruby.evaluator.ASTInterpreter.INTERPRET_METHOD(ASTInterpreter.java:75)
            at org.jruby.internal.runtime.methods.InterpretedMethod.call(InterpretedMethod.java:112)
            at org.jruby.internal.runtime.methods.InterpretedMethod.call(InterpretedMethod.java:126)
            at org.jruby.internal.runtime.methods.DefaultMethod.call(DefaultMethod.java:163)
            at org.jruby.javasupport.proxy.JavaProxyConstructor$2.invoke(JavaProxyConstructor.java:224)
            at org.jruby.proxy.hudson.model.Descriptor$Proxy0.configure(Unknown Source)
            at jenkins.model.Jenkins.configureDescriptor(Jenkins.java:2772)
            at jenkins.model.Jenkins.doConfigSubmit(Jenkins.java:2735)
            ... 62 more
            Caused by: java.lang.RuntimeException: Failed to serialize org.jruby.javasupport.proxy.JavaProxyConstructor$2#val$self for class org.jruby.javasupport.proxy.JavaProxyConstructor$2
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 97 more
            Caused by: com.thoughtworks.xstream.converters.ConversionException: Could not call org.jruby.java.proxies.ConcreteJavaProxy.writeObject() : Could not call org.jruby.RubyObject.writeObject() : Failed to serialize ruby.RubyPlugin#ruby for class ruby.RubyPlugin
            ---- Debugging information ----
            message             : Could not call org.jruby.RubyObject.writeObject()
            cause-exception     : java.lang.RuntimeException
            cause-message       : Failed to serialize ruby.RubyPlugin#ruby for class ruby.RubyPlugin
            -------------------------------
            message             : Could not call org.jruby.java.proxies.ConcreteJavaProxy.writeObject()
            cause-exception     : com.thoughtworks.xstream.converters.ConversionException
            cause-message       : Could not call org.jruby.RubyObject.writeObject() : Failed to serialize ruby.RubyPlugin#ruby for class ruby.RubyPlugin
            -------------------------------
            at com.thoughtworks.xstream.converters.reflection.SerializationMethodInvoker.callWriteObject(SerializationMethodInvoker.java:141)
            at com.thoughtworks.xstream.converters.reflection.SerializableConverter.doMarshal(SerializableConverter.java:232)
            at com.thoughtworks.xstream.converters.reflection.AbstractReflectionConverter.marshal(AbstractReflectionConverter.java:72)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 106 more
            Caused by: com.thoughtworks.xstream.converters.ConversionException: Could not call org.jruby.RubyObject.writeObject() : Failed to serialize ruby.RubyPlugin#ruby for class ruby.RubyPlugin
            ---- Debugging information ----
            message             : Could not call org.jruby.RubyObject.writeObject()
            cause-exception     : java.lang.RuntimeException
            cause-message       : Failed to serialize ruby.RubyPlugin#ruby for class ruby.RubyPlugin
            -------------------------------
            at com.thoughtworks.xstream.converters.reflection.SerializationMethodInvoker.callWriteObject(SerializationMethodInvoker.java:141)
            at com.thoughtworks.xstream.converters.reflection.SerializableConverter.doMarshal(SerializableConverter.java:232)
            at com.thoughtworks.xstream.converters.reflection.AbstractReflectionConverter.marshal(AbstractReflectionConverter.java:72)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.reflection.SerializableConverter$1.writeToStream(SerializableConverter.java:113)
            at com.thoughtworks.xstream.core.util.CustomObjectOutputStream.writeObjectOverride(CustomObjectOutputStream.java:84)
            at java.io.ObjectOutputStream.writeObject(ObjectOutputStream.java:343)
            at org.jruby.RubyBasicObject.writeObject(RubyBasicObject.java:3023)
            at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
            at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
            at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
            at java.lang.reflect.Method.invoke(Method.java:606)
            at com.thoughtworks.xstream.converters.reflection.SerializationMethodInvoker.callWriteObject(SerializationMethodInvoker.java:135)
            ... 113 more
            Caused by: java.lang.RuntimeException: Failed to serialize ruby.RubyPlugin#ruby for class ruby.RubyPlugin
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.reflection.SerializableConverter$1.defaultWriteObject(SerializableConverter.java:187)
            at com.thoughtworks.xstream.converters.reflection.SerializableConverter.doMarshal(SerializableConverter.java:251)
            at com.thoughtworks.xstream.converters.reflection.AbstractReflectionConverter.marshal(AbstractReflectionConverter.java:72)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.reflection.SerializableConverter$1.writeToStream(SerializableConverter.java:113)
            at com.thoughtworks.xstream.core.util.CustomObjectOutputStream.writeObjectOverride(CustomObjectOutputStream.java:84)
            at java.io.ObjectOutputStream.writeObject(ObjectOutputStream.java:343)
            at org.jruby.RubyBasicObject.writeObject(RubyBasicObject.java:3023)
            at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
            at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
            at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
            at java.lang.reflect.Method.invoke(Method.java:606)
            at com.thoughtworks.xstream.converters.reflection.SerializationMethodInvoker.callWriteObject(SerializationMethodInvoker.java:135)
            ... 128 more
            Caused by: java.lang.RuntimeException: Failed to serialize org.jruby.embed.ScriptingContainer#provider for class org.jruby.embed.ScriptingContainer
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 152 more
            Caused by: java.lang.RuntimeException: Failed to serialize org.jruby.embed.internal.AbstractLocalContextProvider#config for class org.jruby.embed.internal.SingleThreadLocalContextProvider
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 161 more
            Caused by: java.lang.RuntimeException: Failed to serialize org.jruby.RubyInstanceConfig#contextLoader for class org.jruby.RubyInstanceConfig
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 170 more
            Caused by: java.lang.RuntimeException: Failed to serialize org.apache.tools.ant.AntClassLoader#parent for class hudson.ClassicPluginStrategy$AntClassLoader2
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 179 more
            Caused by: java.lang.RuntimeException: Failed to serialize hudson.ClassicPluginStrategy$DependencyClassLoader#transientDependencies for class hudson.ClassicPluginStrategy$DependencyClassLoader
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 188 more
            Caused by: java.lang.RuntimeException: Failed to serialize hudson.PluginWrapper#parent for class hudson.PluginWrapper
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.collections.AbstractCollectionConverter.writeItem(AbstractCollectionConverter.java:64)
            at com.thoughtworks.xstream.converters.collections.CollectionConverter.marshal(CollectionConverter.java:55)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 197 more
            Caused by: java.lang.RuntimeException: Failed to serialize hudson.PluginManager#context for class hudson.LocalPluginManager
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 212 more
            Caused by: java.lang.RuntimeException: Failed to serialize winstone.WebAppConfiguration#ownerHostConfig for class winstone.WebAppConfiguration
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 221 more
            Caused by: java.lang.RuntimeException: Failed to serialize winstone.HostConfiguration#objectPool for class winstone.HostConfiguration
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 230 more
            Caused by: java.lang.RuntimeException: Failed to serialize winstone.ObjectPool#requestHandler for class winstone.ObjectPool
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 239 more
            Caused by: java.lang.RuntimeException: Failed to serialize winstone.BoundedExecutorService#base for class winstone.BoundedExecutorService
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 248 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.util.concurrent.ThreadPoolExecutor#workers for class java.util.concurrent.ThreadPoolExecutor
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 257 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.util.concurrent.ThreadPoolExecutor$Worker#thread for class java.util.concurrent.ThreadPoolExecutor$Worker
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.collections.AbstractCollectionConverter.writeItem(AbstractCollectionConverter.java:64)
            at com.thoughtworks.xstream.converters.collections.CollectionConverter.marshal(CollectionConverter.java:55)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 266 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.lang.Thread#group for class java.lang.Thread
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 281 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.lang.ThreadGroup#threads for class java.lang.ThreadGroup
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 290 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.lang.Thread#threadLocals for class java.lang.Thread
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.collections.AbstractCollectionConverter.writeItem(AbstractCollectionConverter.java:64)
            at com.thoughtworks.xstream.converters.collections.ArrayConverter.marshal(ArrayConverter.java:45)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 299 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.lang.ThreadLocal$ThreadLocalMap#table for class java.lang.ThreadLocal$ThreadLocalMap
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 314 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.lang.ThreadLocal$ThreadLocalMap$Entry#value for class java.lang.ThreadLocal$ThreadLocalMap$Entry
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.collections.AbstractCollectionConverter.writeItem(AbstractCollectionConverter.java:64)
            at com.thoughtworks.xstream.converters.collections.ArrayConverter.marshal(ArrayConverter.java:45)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 323 more
            Caused by: java.lang.RuntimeException: Failed to serialize java.lang.ref.Reference#referent for class java.lang.ref.SoftReference
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 338 more
            Caused by: java.lang.RuntimeException: Failed to serialize org.jruby.runtime.ThreadContext#runtime for class org.jruby.runtime.ThreadContext
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 347 more
            Caused by: java.lang.RuntimeException: Failed to serialize org.jruby.Ruby#errnos for class org.jruby.Ruby
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:208)
            at hudson.util.RobustReflectionConverter$2.visit(RobustReflectionConverter.java:176)
            at com.thoughtworks.xstream.converters.reflection.PureJavaReflectionProvider.visitSerializableFields(PureJavaReflectionProvider.java:135)
            at hudson.util.RobustReflectionConverter.doMarshal(RobustReflectionConverter.java:161)
            at hudson.util.RobustReflectionConverter.marshal(RobustReflectionConverter.java:102)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 356 more
            Caused by: com.thoughtworks.xstream.converters.ConversionException: Could not call org.jruby.RubyClass.writeObject() : can not serialize singleton object
            ---- Debugging information ----
            message             : Could not call org.jruby.RubyClass.writeObject()
            cause-exception     : java.io.IOException
            cause-message       : can not serialize singleton object
            -------------------------------
            at com.thoughtworks.xstream.converters.reflection.SerializationMethodInvoker.callWriteObject(SerializationMethodInvoker.java:141)
            at com.thoughtworks.xstream.converters.reflection.SerializableConverter.doMarshal(SerializableConverter.java:232)
            at com.thoughtworks.xstream.converters.reflection.AbstractReflectionConverter.marshal(AbstractReflectionConverter.java:72)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:43)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:88)
            at com.thoughtworks.xstream.converters.collections.AbstractCollectionConverter.writeItem(AbstractCollectionConverter.java:64)
            at com.thoughtworks.xstream.converters.collections.MapConverter.marshal(MapConverter.java:59)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller.convert(AbstractReferenceMarshaller.java:69)
            at com.thoughtworks.xstream.core.TreeMarshaller.convertAnother(TreeMarshaller.java:58)
            at com.thoughtworks.xstream.core.AbstractReferenceMarshaller$1.convertAnother(AbstractReferenceMarshaller.java:84)
            at hudson.util.RobustReflectionConverter.marshallField(RobustReflectionConverter.java:217)
            at hudson.util.RobustReflectionConverter$2.writeField(RobustReflectionConverter.java:204)
            ... 365 more
            Caused by: java.io.IOException: can not serialize singleton object
            at org.jruby.RubyBasicObject.writeObject(RubyBasicObject.java:3012)
            at sun.reflect.GeneratedMethodAccessor48.invoke(Unknown Source)
            at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
            at java.lang.reflect.Method.invoke(Method.java:606)
            at com.thoughtworks.xstream.converters.reflection.SerializationMethodInvoker.callWriteObject(SerializationMethodInvoker.java:135)
            ... 378 more

=end
