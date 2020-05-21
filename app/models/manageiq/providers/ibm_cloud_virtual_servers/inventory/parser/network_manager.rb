class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::NetworkManager < ManageIQ::Providers::Inventory::Parser
	def parse

	  collector.networks.each do |network|
	    persister_cloud_networks = self.persister.cloud_networks.build(
          :ems_ref             => network['networkID'],
          :name                => network['name'],
          :cidr                => '',
          :enabled             => true,
          :orchestration_stack => '',
		  :status			   => 'active',
        )

		subnetId = "#{network['networkID']}-#{network['type']}"

		persister_cloud_subnet = self.persister.cloud_subnets.build(
          :cloud_network => persister_cloud_networks,
          :cidr          => network['cidr'],
          :ems_ref       => subnetId,
          :gateway       => network['gateway'],
          :name          => "#{network['name']}-#{network['type']}",
          :status        => "active",
		)
	
	  	collector.ports(network['networkID']).each do |port|
          vmiId = port['pvmInstance']['pvmInstanceID']

	      persister_network_port = self.persister.network_ports.build(
        	:name            => port['portID'],
		    :ems_ref         => port['portID'],
    	    :status          => port['status'],
	        :mac_address     => port['macAddress'],
    	    :device_ref      => vmiId,
            :device          => persister.vms.lazy_find(vmiId),
	        #:security_groups => '',
    	    #:source          => '',
	      )

        self.persister.cloud_subnet_network_ports.build(
           :network_port => persister_network_port,
           :address      => port['ipAddress'],
		   :cloud_subnet => persister_cloud_subnet,
        )
	    end
	  end
	end
end
