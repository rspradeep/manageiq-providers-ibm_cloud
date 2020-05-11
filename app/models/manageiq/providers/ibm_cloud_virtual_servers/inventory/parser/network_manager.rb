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
	
	  	collector.ports(network['networkID']).each do |port|
	      persister_network_port = self.persister.network_ports.build(
        	:name            => port['portID'],
		    :ems_ref         => port['portID'],
    	    :status          => port['status'],
	        :mac_address     => port['macAddress'],
    	    :device_ref      => port['pvmInstanceID'],
            #:device          => '',
	        #:security_groups => '',
    	    #:source          => '',
	      )

		  # TODO: implement, do lazy_find
		  next

          self.persister.cloud_subnet_network_ports.build(
            :address      => port['ipAddress'],
			:cloud_subnet => 'TODO',
            :network_port => persister_network_port,
          )
	    end
	  end
	end
end
