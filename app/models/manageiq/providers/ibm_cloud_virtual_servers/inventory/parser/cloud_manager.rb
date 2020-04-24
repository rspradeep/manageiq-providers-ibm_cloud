class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::CloudManager < ManageIQ::Providers::Inventory::Parser

  def parse
  self.collector.vms().each do |vmi|
		persister_instance = persister.vms.build(
			:availability_zone => "",
			:description       => "IBM Power Server",
			:ems_ref           => vmi["pvmInstanceID"],
			:flavor            => "",
			:location          => "unknown",
			:name              => vmi["serverName"],
			:vendor			   => 'unknown',
			:genealogy_parent  => "",
			:connection_state  => "connected",
			:raw_power_state   => vmi["status"],
			:uid_ems           => vmi["pvmInstanceID"],
		)
	end
  end
end
