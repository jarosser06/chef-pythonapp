require 'chef/resource'

class Chef
  class Resource
    class PythonApp < Chef::Resource::GenericApp
      def initialize(name, run_context=nil)
        super
        @resource_name = :python_app
        @provider = Chef::Provider::PythonApp
      end

      def eggs(arg=nil)
        set_or_return(:deploy_key,
                      arg,
                      kind_of: Array,
                      default: [])
      end
    end
  end
end
