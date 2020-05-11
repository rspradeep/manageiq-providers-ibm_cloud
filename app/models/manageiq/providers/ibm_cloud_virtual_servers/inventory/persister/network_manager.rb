class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Persister::NetworkManager < ManageIQ::Providers::Inventory::Persister
  def initialize_inventory_collections
	%i(vms cloud_networks network_ports cloud_subnet_network_ports availability_zones).each do |name|
      add_collection(network, name)
    end
  end
end
