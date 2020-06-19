class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector::CloudManager < ManageIQ::Providers::Inventory::Collector
  include ManageIQ::Providers::IbmCloudVirtualServers::APICalls

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

  def images
    connection
    get_images(
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
end
