class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector::CloudManager < ManageIQ::Providers::Inventory::Collector
  def connection
    @connection ||= manager.connect
  end

  def vms
    crn, region = get_service_crn_region(@connection.token, @connection.guid)
    get_pcloudpvminstances(@connection.token, @connection.guid, crn, region)
    # [
    #   OpenStruct.new(:id => '1', :name => 'funky', :location => 'dc-1', :vendor => 'unknown'),
    #   OpenStruct.new(:id => '2', :name => 'bunch', :location => 'dc-1', :vendor => 'unknown')
    # ]
  end
end
