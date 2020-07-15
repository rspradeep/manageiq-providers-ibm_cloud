class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::StorageManager < ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister
  def initialize_inventory_collections
    initialize_cloud_inventory_collections
    initialize_storage_inventory_collections
  end
end
