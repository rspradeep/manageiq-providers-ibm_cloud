class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector::StorageManager < ManageIQ::Providers::Inventory::Collector
  include ManageIQ::Providers::IbmCloudVirtualServers::VolAPICalls

  def connection
    @connection ||= manager.connect
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
end