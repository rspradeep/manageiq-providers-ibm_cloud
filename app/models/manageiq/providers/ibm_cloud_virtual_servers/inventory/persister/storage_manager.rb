class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::StorageManager < ManageIQ::Providers::Inventory::Persister
  def initialize_inventory_collections
    add_collection(storage, :cloud_volumes) do |builder|
      builder.add_default_values(:ems_id => manager.id)
    end
  end
end
