class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::ProvisionWorkflow < ::MiqProvisionCloudWorkflow
      def get_timezones(_options = {})
      end

      def allowed_instance_types(_options = {})
      end
    
      def availability_zone_to_cloud_network(src)
      end
    
      private
    
      def dialog_name_from_automate(message = 'get_dialog_name')
      end
    
      def self.provider_model
        ManageIQ::Providers::IbmCloudVirtualServers::CloudManager
      end
end