class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::CloudManager < ManageIQ::Providers::Inventory::Parser 

  def instances
	self.collector.vms.each do |instance|
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
		
		imageID = instance['imageID']

		network =
		{
			:description => 'private',
			:ipaddress   => '192.168.0.1',
			:hostname    => 'test.de',
		}	

		yield vmi, hardware, imageID, network
	end
  end
 

  def images
		images = []

		self.collector.images.each do |ibm_image|
			id    = ibm_image['imageID']
			name  = "#{ibm_image['name']}, #{ibm_image['specifications']['operatingSystem']}"
			desc  = ibm_image["specifications"].fetch_values(*%w[operatingSystem architecture endianness]).join('-')

			images << 
			{
		        :uid_ems            => id,
	   		    :ems_ref            => id,
		        :name               => name,
		        :description        => desc,
		        :location           => "unknown",
		        :vendor             => "ibm",
		        :connection_state   => "connected",
		        :raw_power_state    => "never",
		        :template           => true,
		        :publicly_available => true,
			}
		end

		images
  end

  def vmiOS(images, imageID)
		# vmiImage = images.find { |image| image['uid_ems'] == imageID }
		return 'redhat'
  end

  def parse
		images.each do |image| 
			self.persister.miq_templates.build(image)
		end

		instances do |vmi, hardware, imageID, network|
			# saving general VMI information
			ps_vmi = self.persister.vms.build(vmi)

			# saving hardware information (CPU, Memory, etc.)
			hardware[:vm_or_template] = ps_vmi
			ps_hardware = self.persister.hardwares.build(hardware)

			# saving OS information
			system = { :vm_or_template => ps_vmi, :product_name => vmiOS(images, imageID) }
			self.persister.operating_systems.build(system)

			# saving network information
			# network[:hardware] = ps_hardware
			# ps_networks = self.persister.networks.build(network)
		end  	
	end
  end
