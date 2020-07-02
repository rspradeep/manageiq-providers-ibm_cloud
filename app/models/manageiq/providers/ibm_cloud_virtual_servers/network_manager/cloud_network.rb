class ManageIQ::Providers::IbmCloudVirtualServers::NetworkManager::CloudNetwork < ::CloudNetwork
    supports :delete do
        if number_of(:vms) > 0
            unsupported_reason_add(:delete, _("The Network has active VMIs related to it"))
        end
    end

    def delete_cloud_network_queue(userid)
        task_opts = {
          :action => "deleting cloud network, userid: #{userid}",
          :userid => userid
        }

        queue_opts = {
          :class_name  => self.class.name,
          :method_name => 'raw_delete_cloud_network',
          :instance_id => id,
          :priority    => MiqQueue::HIGH_PRIORITY,
          :role        => 'ems_operations',
          :zone        => ext_management_system.my_zone,
          :args        => []
        }

        MiqTask.generic_action_with_callback(task_opts, queue_opts)
    end

    def raw_delete_cloud_network
        begin
            ext_management_system.with_provider_connection({:target => 'network'}) do |net_control|
                net_control.del_network(ems_ref)
            end
        rescue => e
            _log.error "network=[#{name}], error: #{e}"
        end
    end
end