class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::StorageManager < ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser
  def parse
    volumes do |volume|
      persister.cloud_volumes.build(volume)
    end
  end
end
