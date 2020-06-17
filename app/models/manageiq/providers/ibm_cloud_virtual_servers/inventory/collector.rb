class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager

  include ManageIQ::Providers::IbmCloudVirtualServers::APICalls
  include ManageIQ::Providers::IbmCloudVirtualServers::NetAPICalls
  include ManageIQ::Providers::IbmCloudVirtualServers::VolAPICalls
end
