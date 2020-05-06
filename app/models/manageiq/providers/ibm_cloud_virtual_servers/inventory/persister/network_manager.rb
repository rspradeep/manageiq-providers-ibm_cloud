class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::NetworkManager < ManageIQ::Providers::Inventory::Persister

  def initialize_inventory_collections
	%i(vms availability_zones).each do |name|
   		add_collection(cloud, name) do |builder|
			builder.add_properties(:parent => manager.parent_manager, :strategy => :local_db_cache_all)
		end
  	end
  end

end
