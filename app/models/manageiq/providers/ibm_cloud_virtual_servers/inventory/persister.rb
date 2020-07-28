class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister < ManageIQ::Providers::Inventory::Persister
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager


  def initialize_inventory_collections
    initialize_cloud_inventory_collections
    initialize_network_inventory_collections
    initialize_storage_inventory_collections
  end

  private

  def initialize_cloud_inventory_collections
    %i[availability_zones vms hardwares disks operating_systems networks cloud_volumes].each do |name|
      add_cloud_collection(name)
    end

    add_cloud_collection(:miq_templates) do |builder|
      builder.add_properties(:model_class => ::ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Template)
    end

    add_advanced_settings
  end

  def initialize_network_inventory_collections
    %i[cloud_networks cloud_subnets network_ports cloud_subnet_network_ports availability_zones].each do |name|
      add_network_collection(name)
    end
  end

  def initialize_storage_inventory_collections
    %i[cloud_volumes].each do |name|
      add_storage_collection(name)
    end
  end

  def add_cloud_collection(name)
    add_collection(cloud, name) do |builder|
      builder.add_properties(:parent => cloud_manager)
      yield builder if block_given?
    end
  end

  def add_network_collection(name)
    add_collection(network, name) do |builder|
      builder.add_properties(:parent => network_manager)
      yield builder if block_given?
    end
  end

  def add_storage_collection(name)
    add_collection(storage, name) do |builder|
      builder.add_properties(:parent => storage_manager)
      yield builder if block_given?
    end
  end

  def add_advanced_settings
    add_collection(cloud, :vms_and_templates_advanced_settings) do |builder|
      builder.add_properties(
        :manager_ref                  => %i(resource),
        :model_class                  => ::AdvancedSetting,
        :parent_inventory_collections => %i(vms)
      )
    end
  end

  def cloud_manager
    manager.kind_of?(EmsCloud) ? manager : manager.parent_manager
  end

  def network_manager
    manager.kind_of?(EmsNetwork) ? manager : manager.network_manager
  end

  def storage_manager
    manager.kind_of?(EmsStorage) ? manager : manager.storage_manager
  end
end
