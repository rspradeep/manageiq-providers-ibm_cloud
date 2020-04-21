class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :CloudManager
  include ManageIQ::Providers::IbmCloudVirtualServers::APICalls
end
