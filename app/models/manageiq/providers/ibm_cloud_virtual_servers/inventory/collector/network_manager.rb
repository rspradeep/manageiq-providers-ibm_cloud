class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector::NetworkManager < ManageIQ::Providers::Inventory::Collector
  include ManageIQ::Providers::IbmCloudVirtualServers::NetAPICalls

  def connection
    @connection ||= manager.connect
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
