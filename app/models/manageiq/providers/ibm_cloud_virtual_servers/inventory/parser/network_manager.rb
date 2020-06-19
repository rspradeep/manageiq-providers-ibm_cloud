class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::NetworkManager < ManageIQ::Providers::Inventory::Parser
  def parse
    collector.networks.each do |network|
      persister_cloud_networks = persister.cloud_networks.build(
        :ems_ref             => network['networkID'],
        :name                => network['name'],
        :cidr                => '',
        :enabled             => true,
        :orchestration_stack => '',
        :status              => 'active'
      )

      subnet_id = "#{network['networkID']}-#{network['type']}"

      persister_cloud_subnet = persister.cloud_subnets.build(
        :cloud_network    => persister_cloud_networks,
        :cidr             => network['cidr'],
        :ems_ref          => subnet_id,
        :gateway          => network['gateway'],
        :name             => "#{network['name']}-#{network['type']}",
        :status           => "active",
        :dns_nameservers  => network['dnsServers'],
        :ip_version       => '4',
        :network_protocol => 'IPv4'
      )

      collector.ports(network['networkID']).each do |port|
        vmi_id = port['pvmInstance']['pvmInstanceID']

        persister_network_port = persister.network_ports.build(
          :name        => port['portID'],
          :ems_ref     => port['portID'],
          :status      => port['status'],
          :mac_address => port['macAddress'],
          :device_ref  => vmi_id,
          :device      => persister.vms.lazy_find(vmi_id)
          #:security_groups => '',
          #:source          => '',
        )

        persister.cloud_subnet_network_ports.build(
          :network_port => persister_network_port,
          :address      => port['ipAddress'],
          :cloud_subnet => persister_cloud_subnet
        )
      end
    end
  end
end
