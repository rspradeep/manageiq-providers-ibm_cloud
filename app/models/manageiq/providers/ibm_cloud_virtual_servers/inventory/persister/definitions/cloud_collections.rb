module ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::Definitions::CloudCollections
  extend ActiveSupport::Concern

  def initialize_cloud_inventory_collections
    %i(vms hardwares operating_systems networks).each do |name|
      add_collection(cloud, name)
    end
  end
end
