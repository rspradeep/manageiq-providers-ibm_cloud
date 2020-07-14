class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::NetworkManager < ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister
  def initialize_inventory_collections
    initialize_cloud_inventory_collections
    initialize_network_inventory_collections
  end
end
