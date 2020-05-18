class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::NetworkManager < ManageIQ::Providers::Inventory::Persister
  def initialize_inventory_collections
	%i(cloud_networks cloud_subnets network_ports cloud_subnet_network_ports availability_zones).each do |name|
      add_collection(network, name)
    end

    %i(vms).each do |name|
       add_collection(cloud, name) do |builder|
           builder.add_properties(
             :parent   => manager.parent_manager,
             :strategy => :local_db_cache_all
           )
       end
    end
  end
end
