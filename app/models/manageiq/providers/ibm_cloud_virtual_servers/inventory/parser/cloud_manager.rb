class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::CloudManager < ManageIQ::Providers::Inventory::Parser
  
  def instances
	self.collector.vms().each do |instance|
		vmi = {
			:availability_zone => "",
            :description       => "IBM Cloud Server",
            :ems_ref           => instance["pvmInstanceID"],
            :flavor            => "",
            :location          => "unknown",
            :name              => instance["serverName"],
            :vendor            => 'IBM',
            :genealogy_parent  => "",
            :connection_state  => "connected",
            :raw_power_state   => instance["status"],
            :uid_ems           => instance["pvmInstanceID"],
		}

		hardware =
		{
			:cpu_total_cores => Float(instance['processors']),
			:memory_mb       => Integer(instance['memory']) * 1024,
		}		

		yield vmi, hardware if block_given?
	end
  end		
 
  def parse
		instances do |vmi, hardware| 
			# saving general VMI information
			ps_vmi = self.persister.vms.build(vmi)

			# saving hardware information (CPU, Memory, etc.)
			hardware[:vm_or_template] = ps_vmi
			ps_hardware = self.persister.hardwares.build(hardware)

			# saving network information
			# TODO: coming soon
		end
		  	
	end
  end
