require 'chef/provider'

class Chef
  class Provider
    class PythonApp < Chef::Provider::GenericApp
      def load_current_resource
        @current_resource ||= Chef::Resource::PythonApp.new(new_resource.name)
        @current_resource
      end

      def action_deploy
        Chef::Log.info("DEBUG!!!!!!!!!!")
        Chef::Log.info(new_resource)
        Chef::Log.info(new_resource.repository)

      end

      def action_remove

      end
    end
  end
end
