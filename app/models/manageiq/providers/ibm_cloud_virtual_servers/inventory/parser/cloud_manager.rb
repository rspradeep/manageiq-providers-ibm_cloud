class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::CloudManager < ManageIQ::Providers::Inventory::Parser
  def instances
    collector.vms.each do |instance|
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
          :raw_power_state   => instance["status"] == 'ACTIVE' ? 'on' : 'off',
          :uid_ems           => instance["pvmInstanceID"],
        }

      hardware =
        {
          :cpu_total_cores => Float(instance['processors']).ceil,
          :memory_mb       => Integer(instance['memory']) * 1024,
        }

      image_id = instance['imageID']

      network =
        {
          :description => 'private',
          :ipaddress   => '192.168.0.1',
          :hostname    => 'test.de',
        }

      yield vmi, hardware, image_id, network
    end
  end

  def images
    images = []

    collector.images.each do |ibm_image|
      id = ibm_image['imageID']
      name  = "#{ibm_image['name']}, #{ibm_image['specifications']['operatingSystem']}"
      desc  = ibm_image["specifications"].fetch_values('operatingSystem', 'architecture', 'endianness').join('-')

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

  def vmi_os(_images, _image_id)
    # vmiImage = images.find { |image| image['uid_ems'] == image_id }
    'redhat'
  end

  def parse
    images.each do |image|
      persister.miq_templates.build(image)
    end

    instances do |vmi, hardware, image_id, _network|
      # saving general VMI information
      ps_vmi = persister.vms.build(vmi)

      # saving hardware information (CPU, Memory, etc.)
      hardware[:vm_or_template] = ps_vmi
      persister.hardwares.build(hardware)

      # saving OS information
      system = {:vm_or_template => ps_vmi, :product_name => vmi_os(images, image_id)}
      persister.operating_systems.build(system)

      # saving network information
      # network[:hardware] = ps_hardware
      # ps_networks = self.persister.networks.build(network)
    end
  end
end
