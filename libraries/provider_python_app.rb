require 'chef/provider'
require 'chef/mixin/shell_out'

include Chef::Mixin::ShellOut

class Chef
  class Provider
    class PythonApp < Chef::Provider::GenericApp
      def load_current_resource
        @current_resource ||= Chef::Resource::PythonApp.new(new_resource.name)
        @current_resource
      end

      def initialize(new_resource, run_context)
        super
      end

      def action_deploy
        run_checkout
        install_packages

        if new_resource.updated_by_last_action?
          callback(:after_checkout, new_resource.after_checkout)
        end
        web_server_setup
      end

      def action_remove

      end

      def install_packages
        ## Give the option of pip
        req_txt = ::File.join(new_resource.path, 'requirements.txt')

        if run_context.loaded_recipes.include?('python::pip')
          Chef::Log.debug('Found python::pip included on the node ... using pip')
          new_resource.eggs.each do |egg|
            pip_resource = Chef::Resource::PythonPip.new(egg, run_context)
            pip_resource.run_action :install

            new_resource.updated_by_last_action true if pip_resource.updated_by_last_action?
          end

          if ::File.exist?(req_txt) && new_resource.use_requirements_file
            case run_context.node.platform_family
            when 'debian'
              pip_cmd = '/usr/local/bin/pip'
            when 'rhel', 'fedora'
              pip_cmd = '/usr/bin/pip'
            end

            shell_out("#{pip_cmd} install -r #{new_resource.path}/requirements.txt")
          end
        else
          Chef::Log.debug('Could not find the python::pip recipe on the node ... using easy_install')
          new_resource.eggs.each do |egg|
            easy_install = Chef::Resource::EasyInstall.new(egg, run_context)
            easy_install = egg
            easy_install.run_action :install

            new_resource.updated_by_last_action true if easy_install.updated_by_last_action?
          end

          if ::File.exist?(req_txt) && new_resource.use_requirements_file
            Chef::Log.debug('Unable to use requirements.txt file without pip installed')
          end
        end
      end

      def web_conf
        if new_resource.web_template.nil?
          "pythonapp-#{new_resource.web_server}.erb"
        else
          new_resource.web_template
        end
      end

      ## Override super
      def web_conf_cookbook
        if new_resource.web_template.nil?
          return 'pythonapp'
        else
          return new_resource.cookbook_name.to_s
        end
      end
    end
  end
end
