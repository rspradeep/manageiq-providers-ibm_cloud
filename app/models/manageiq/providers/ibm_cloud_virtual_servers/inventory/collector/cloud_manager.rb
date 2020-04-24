class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector::CloudManager < ManageIQ::Providers::Inventory::Collector
  include ManageIQ::Providers::IbmCloudVirtualServers::APICalls

  def connection
    @connection ||= manager.connect
  end

  def vms
    self.connection
    self.get_pcloudpvminstances(
      @connection[:token],
      @connection[:guid],
      @connection[:crn],
      @connection[:region])
  end
end
