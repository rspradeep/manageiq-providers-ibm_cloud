module ManageIQ
  module Providers
    module IbmCloudVirtualServers
      class Engine < ::Rails::Engine
        isolate_namespace ManageIQ::Providers::IbmCloudVirtualServers

        config.autoload_paths << root.join('lib').to_s

        def self.vmdb_plugin?
          true
        end

        def self.plugin_name
          _('ManageIQ Providers Ibm Cloud Virtual Servers')
        end
      end
    end
  end
end
