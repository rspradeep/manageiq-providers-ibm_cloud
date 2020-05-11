class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector::NetworkManager < ManageIQ::Providers::Inventory::Collector
  include ManageIQ::Providers::IbmCloudVirtualServers::NetAPICalls

  def connection
    @connection ||= manager.connect
  end

  def networks
    self.connection

    self.get_networks(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region])
  end

  def ports(networkId)
    self.connection

    self.get_ports(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region],
	  networkId)
  end
end
