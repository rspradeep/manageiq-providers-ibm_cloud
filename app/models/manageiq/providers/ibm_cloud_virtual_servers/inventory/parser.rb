class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser < ManageIQ::Providers::Inventory::Parser
  require_nested :CloudManager
  require_nested :NetworkManager
end
