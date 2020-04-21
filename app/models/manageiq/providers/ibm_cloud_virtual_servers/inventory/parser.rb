class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser < ManageIQ::Providers::Inventory::Parser
  require_nested :CloudManager 

  def test
	return "test"
  end
end
