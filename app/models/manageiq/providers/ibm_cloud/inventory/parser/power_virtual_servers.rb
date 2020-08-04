class ManageIQ::Providers::IbmCloud::Inventory::Parser::PowerVirtualServers < ManageIQ::Providers::IbmCloud::Inventory::Parser
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager

  attr_reader :img_to_os, :subnet_to_ext_ports

  def initialize
    @img_to_os           = {}
    @subnet_to_ext_ports = {}
  end

  def parse
    images
    volumes
    instances
    networks
    sshkeys
  end

  def instances
    collector.vms.each do |instance|
      # saving general VMI information
      ps_vmi = persister.vms.build(
        :description       => "IBM Cloud Server",
        :ems_ref           => instance["pvmInstanceID"],
        :flavor            => "",
        :location          => "unknown",
        :name              => instance["serverName"],
        :vendor            => "ibm",
        :connection_state  => "connected",
        :raw_power_state   => instance["status"] == "ACTIVE" ? "on" : "off",
        :uid_ems           => instance["pvmInstanceID"],
      )

      # saving hardware information (CPU, Memory, etc.)
      ps_hw = persister.hardwares.build(
        :vm_or_template  => ps_vmi,
        :cpu_total_cores => Float(instance["processors"]).ceil,
        :memory_mb       => Integer(instance["memory"]) * 1024,
      )

      # saving instance disk information
      instance["volumeIDs"].each do |vol_id|
        persister.disks.build(
          :hardware        => ps_hw,
          :device_name     => vol_id,
          :device_type     => "block",
          :controller_type => "ibm",
          :backing         => persister.cloud_volumes.find(vol_id),
          :location        => vol_id,
          :size            => 20
        )
      end

      # saving OS information
      os = img_to_os[instance['imageID']] || pub_img_os(instance['imageID'])
      persister.operating_systems.build(
        :vm_or_template => ps_vmi,
        :product_name   => os
      )

      # saving exteral network ports
      external_ports = instance["networks"].reject { |net| net["externalIP"].blank? }
      external_ports.each do |ext_port|
        net_id = ext_port['networkID']
        subnet_to_ext_ports[net_id] ||= []
        subnet_to_ext_ports[net_id]  << ext_port
      end

      persister.vms_and_templates_advanced_settings.build(
        :resource     => ps_vmi,
        :name         => 'processors',
        :display_name => N_('Actual CPU amount'),
        :description  => N_('A floating value indicating the amount of CPUs given to this instance'),
        :value        => instance['processors'],
        :read_only    => true
      )
    end
  end

  def pub_img_os(img_id)
    collector.image(img_id)&.dig("specifications", "operatingSystem")
  end

  def images
    collector.images.each do |ibm_image|
      id    = ibm_image['imageID']
      name  = ibm_image['name']

      os      = ibm_image['specifications']['operatingSystem']
      arch    = ibm_image['specifications']['architecture']
      endian  = ibm_image['specifications']['endianness']
      desc    = "System: #{os}, Architecture: #{arch}, Endianess: #{endian}"

      img_to_os[id] = os
      persister.miq_templates.build(
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
      )
    end
  end

  def volumes
    collector.volumes.each do |vol|
      persister.cloud_volumes.build(
        :ems_ref           => vol['volumeID'],
        :name              => vol['name'],
        :status            => vol['state'],
        :bootable          => vol['bootable'],
        :creation_time     => vol['creationDate'],
        :description       => 'IBM Cloud Block-Storage Volume',
        :volume_type       => vol['diskType'],
        :size              => vol['size'],
      )
    end
  end

  def networks
    collector.networks.each do |network|
      persister_cloud_networks = persister.cloud_networks.build(
        :ems_ref => "#{network['networkID']}-#{network['type']}",
        :name    => "#{network['name']}-#{network['type']}",
        :cidr    => "",
        :enabled => true,
        :status  => 'active'
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

      external_ports = subnet_to_ext_ports[network['networkID']] || []
      external_ports.each do |port|
        port_ps = mac_to_port[port['macAddress']]

        persister.cloud_subnet_network_ports.build(
          :network_port => port_ps,
          :address      => port['externalIP'],
          :cloud_subnet => persister_cloud_subnet
        )
      end
    end
  end

  def sshkeys
    collector.sshkeys.each do |tkey|
      tenant_key = {
        :creationDate => tkey['creationDate'],
        :name         => tkey['name'],
        :sshKey       => tkey['sshKey'],
      }

      # save the tenant instance
      persister.auth_key_pairs.build(:name => tenant_key[:name])
    end
  end
end
