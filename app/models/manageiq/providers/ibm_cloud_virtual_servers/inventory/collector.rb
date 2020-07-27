class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager

  def connection
    @connection ||= manager.connect
  end

  def power_iaas
    @power_iaas ||= IbmCloud::API::PowerIaas.new(*connection.values_at(:region, :guid, :token, :crn))
  end

  def resource_controller
    @resource_controller ||= IbmCloud::API::ResourceController.new(connection[:token])
  end

  def vms
    power_iaas.get_pvm_instances
  end

  def networks
    power_iaas.get_networks
  end

  def image(img_id)
    power_iaas.get_image(img_id)
  end

  def images
    power_iaas.get_images
  end

  def volumes
    power_iaas.get_volumes
  end

  def volume(volume_id)
    power_iaas.get_volume(volume_id)
  end

  def networks
    power_iaas.get_networks
  end

  def ports(network_id)
    power_iaas.get_network_ports(network_id)
  end

  def tenant_id
    power_iaas_service = resource_controller.get_resource(connection[:guid])
    power_iaas_service&.account_id
  end

  def sshkeys
    power_iaas.get_tenant_ssh_keys(tenant_id)
  end
end
