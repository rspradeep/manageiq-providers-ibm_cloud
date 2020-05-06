class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::CloudManager < ManageIQ::Providers::Inventory::Persister
  include ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::Definitions::CloudCollections

  def initialize_inventory_collections
    initialize_cloud_inventory_collections
  end
end
