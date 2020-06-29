module ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::Definitions::CloudCollections
  extend ActiveSupport::Concern

  def initialize_cloud_inventory_collections
    %i[availability_zones vms hardwares disks operating_systems networks].each do |name|
      add_collection(cloud, name)
    end

    add_collection(storage, :cloud_volumes)

    add_miq_templates
  end

  def add_miq_templates
    add_collection(cloud, :miq_templates) do |builder|
      builder.add_properties(:model_class => ::ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Template)

      builder.add_default_values(
        :vendor => builder.vendor
      )
    end
  end
end