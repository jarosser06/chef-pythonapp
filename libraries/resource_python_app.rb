require 'chef/resource'

class Chef
  class Resource
    class PythonApp < Chef::Resource::GenericApp
      def initialize(name, run_context=nil)
        super
        @resource_name = :python_app
        @provider = Chef::Provider::PythonApp
      end

      ## List of eggs to be installed
      ## Will use pip if installed otherwise will use easy_install
      def eggs(arg=nil)
        set_or_return(:deploy_key,
                      arg,
                      kind_of: Array,
                      default: [])
      end

      ## flag to automatically install python packages
      ## using the requirements.txt
      ## This will be skipped if pip is installed
      def use_requirements_file(arg=nil)
        set_or_return(:use_requirements_file,
                      arg,
                      kind_of: [TrueClass, FalseClass],
                      default: true)
      end
    end
  end
end
