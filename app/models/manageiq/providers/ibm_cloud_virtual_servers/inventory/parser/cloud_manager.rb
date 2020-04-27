class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::CloudManager < ManageIQ::Providers::Inventory::Parser 

  def instances
	self.collector.vms().each do |instance|
		vmi = 
		{
			:availability_zone => "",
            :description       => "IBM Cloud Server",
            :ems_ref           => instance["pvmInstanceID"],
            :flavor            => "",
            :location          => "unknown",
            :name              => instance["serverName"],
            :vendor            => 'ibm',
            :genealogy_parent  => "",
            :connection_state  => "connected",
            :raw_power_state   => instance["status"],
            :uid_ems           => instance["pvmInstanceID"],
		}
	
		hardware =
		{
			:cpu_total_cores => Float(instance['processors']).ceil,
			:memory_mb       => Integer(instance['memory']) * 1024,
		}		
		
		system =
		{
			:product_name   => 'redhat'
		}

		network =
		{
			:description => 'private',
			:ipaddress   => '192.168.0.1',
			:hostname    => 'test.de',
		}	

		yield vmi, hardware, system, network
	end
  end
 
  def parse
		instances do |vmi, hardware, system, network| 
			# saving general VMI information
			ps_vmi = self.persister.vms.build(vmi)

			# saving hardware information (CPU, Memory, etc.)
			hardware[:vm_or_template] = ps_vmi
			ps_hardware = self.persister.hardwares.build(hardware)

			# saving OS information
			system[:vm_or_template] = ps_vmi
			self.persister.operating_systems.build(system)

			# saving network information
			# network[:hardware] = ps_hardware
			# ps_networks = self.persister.networks.build(network)
		end  	
	end
  end
