class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser < ManageIQ::Providers::Inventory::Parser
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager

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

      hardw =
        {
          :cpu_total_cores => Float(instance['processors']).ceil,
          :memory_mb       => Integer(instance['memory']) * 1024,
        }

      advanced = [ 
        {
          :name         => 'processors',
          :display_name => N_('Actual CPU amount'),
          :description  => N_('A floating value indicating the amount of CPUs given to this instance'),
          :value        => instance['processors'],
          :read_only    => true
        }
      ]

      vol_ids   = instance['volumeIDs']

      img_id    = instance['imageID']

      ext_ports = instance['networks'].reject {|net| net['externalIP'].blank?}

      yield vmi, hardw, vol_ids, img_id, ext_ports, advanced
    end
  end


  def pub_img_os(img_id)
    image = collector.image(img_id)
    !image.nil? ? image['specifications']['operatingSystem'] : nil
  end

  def images
    collector.images.each do |ibm_image|
      id    = ibm_image['imageID']
      name  = ibm_image['name']

      os      = ibm_image['specifications']['operatingSystem']
      arch    = ibm_image['specifications']['architecture']
      endian  = ibm_image['specifications']['endianness']
      desc    = "System: #{os}, Architecture: #{arch}, Endianess: #{endian}"

      image =
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

      yield image, os
    end
  end

  def volumes
    collector.volumes.each do |vol|
      volume =
        {
          :ems_ref           => vol['volumeID'],
          :name              => vol['name'],
          :status            => vol['state'],
          :bootable          => vol['bootable'],
          :creation_time     => vol['creationDate'],
          :description       => 'IBM Cloud Block-Storage Volume',
          :volume_type       => vol['diskType'],
          :size              => vol['size'],
          :availability_zone => Zone.default_zone,
        }

      yield volume
    end
  end

  def sshkeys
    collector.sshkeys.each do |tkey|
      tenant_key = {
        :creationDate => tkey['creationDate'],
        :name         => tkey['name'],
        :sshKey       => tkey['sshKey'],
      }
      yield tenant_key
    end
  end

  def parse
    img_to_os            = {}
    subnet_to_ext_ports  = {}

    images do |image, os|
      img_to_os[image[:ems_ref]] = os
      persister.miq_templates.build(image)
    end

    volumes do |volume|
      ps_vol = persister.cloud_volumes.build(volume)
    end

    instances do |vmi, hardw, vol_ids, img_id, ext_ports, advanced|
      # saving general VMI information
      ps_vmi = persister.vms.build(vmi)

      # saving hardware information (CPU, Memory, etc.)
      hardw[:vm_or_template] = ps_vmi
      ps_hw = persister.hardwares.build(hardw)

      # saving instance disk information
      vol_ids.each do |vol_id|
        disk = persister.disks.find_or_build_by(
          :hardware    => ps_hw,
          :device_name => vol_id
        )

        disk.assign_attributes(
            :device_type     => 'block',
            :controller_type => 'ibm',
            :backing         => persister.cloud_volumes.find(vol_id),
            :location        => vol_id,
            :size            => 20)

      end

      # saving OS information
      os = img_to_os[img_id]
      os ||= pub_img_os(img_id)
      system = {:vm_or_template => ps_vmi, :product_name => os}
      persister.operating_systems.build(system)

      # saving exteral network ports
      ext_ports.each do |ext_port|
        net_id = ext_port['networkID']
        subnet_to_ext_ports[net_id] ||= []
        subnet_to_ext_ports[net_id]  << ext_port
      end

      # settings and values specific to IBM's clouds
      advanced.each do |setting|
        setting[:resource] = ps_vmi
        persister.vms_and_templates_advanced_settings.build(setting)
      end
    end

    collector.networks.each do |network|
      persister_cloud_networks = persister.cloud_networks.build(
        :ems_ref             => "#{network['networkID']}-#{network['type']}",
        :name                => "#{network['name']}-#{network['type']}",
        :cidr                => '',
        :enabled             => true,
        :orchestration_stack => '',
        :status              => 'active'
      )

      persister_cloud_subnet = persister.cloud_subnets.build(
        :cloud_network    => persister_cloud_networks,
        :cidr             => network['cidr'],
        :ems_ref          => network['networkID'],
        :gateway          => network['gateway'],
        :name             => network['name'],
        :status           => "active",
        :dns_nameservers  => network['dnsServers'],
        :ip_version       => '4',
        :network_protocol => 'IPv4'
      )
      
      mac_to_port = {}

      collector.ports(network['networkID']).each do |port|
        vmi_id = port['pvmInstance']['pvmInstanceID']

        persister_network_port = persister.network_ports.build(
          :name        => port['portID'],
          :ems_ref     => port['portID'],
          :status      => port['status'],
          :mac_address => port['macAddress'],
          :device_ref  => vmi_id,
          :device      => persister.vms.lazy_find(vmi_id)
        )

        mac_to_port[port['macAddress']] = persister_network_port

        persister.cloud_subnet_network_ports.build(
          :network_port => persister_network_port,
          :address      => port['ipAddress'],
          :cloud_subnet => persister_cloud_subnet
        )
      end

      ext_ports = subnet_to_ext_ports[network['networkID']]

      (ext_ports || []).each do |port|
        port_ps = mac_to_port[port['macAddress']]

        persister.cloud_subnet_network_ports.build(
          :network_port => port_ps,
          :address      => port['externalIP'],
          :cloud_subnet => persister_cloud_subnet
        )
      end
    end

    sshkeys do |tenant_key|
      # save the tenant instance
      persister.key_pairs.build(:name => tenant_key[:name])
    end
  end
end
