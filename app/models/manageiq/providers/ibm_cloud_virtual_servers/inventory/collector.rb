class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :CloudManager
  require_nested :NetworkManager

  include ManageIQ::Providers::IbmCloudVirtualServers::APICalls  
  include ManageIQ::Providers::IbmCloudVirtualServers::NetAPICalls  
end
