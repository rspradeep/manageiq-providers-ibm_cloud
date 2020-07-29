class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::NetworkManager < ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister
  def storage_manager
    manager.parent_manager.storage_manager
  end
end
