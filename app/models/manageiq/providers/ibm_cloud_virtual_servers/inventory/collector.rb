class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager

  def connection
    @power_iaas ||= begin
      region, guid, token, crn, tenant = manager.connect.values_at(:region, :guid, :token, :crn, :tenant)
      IbmCloud::API::PowerIaas.new(region, guid, token, crn, tenant)
    end
  end

  def vms
    connection.get_pvm_instances
  end

  def networks
    connection.get_networks
  end

  def image(img_id)
    connection.get_image(img_id)
  end

  def images
    connection.get_images
  end

  def volumes
    connection.get_volumes
  end

  def volume(volume_id)
    connection.get_volume(volume_id)
  end

  def networks
    connection.get_networks
  end

  def ports(network_id)
    connection.get_network_ports(network_id)
  end

  def sshkeys
    connection.get_ssh_keys
  end
end
