class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager

  include ManageIQ::Providers::IbmCloudVirtualServers::APICalls
  include ManageIQ::Providers::IbmCloudVirtualServers::NetAPICalls
  include ManageIQ::Providers::IbmCloudVirtualServers::VolAPICalls

  def connection
    @connection ||= manager.connect
  end

  def vms
    connection
    get_pcloudpvminstances(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region]
    )
  end

  def networks
    connection
    get_networks(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region]
    )
  end

  def image(img_id)
    connection
    get_image(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region],
      img_id
    )
  end

  def images
    connection
    get_images(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region]
    )
  end

  def volumes
    connection
    get_volumes(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region]
    )
  end

  def volume(volume_id)
    connection

    volume(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region],
      volume_id
    )
  end

  def networks
    connection

    get_networks(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region]
    )
  end

  def ports(network_id)
    connection

    get_ports(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region],
      network_id
    )
  end
end
