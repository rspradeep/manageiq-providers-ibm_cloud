class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::StorageManager < ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister
  def network_manager
    manager.parent_manager.network_manager
  end
end
