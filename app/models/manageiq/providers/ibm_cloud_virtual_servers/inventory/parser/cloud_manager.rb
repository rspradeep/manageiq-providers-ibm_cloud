class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::CloudManager < ManageIQ::Providers::Inventory::Parser
  VMIs = [{"addresses"=>
   [{"href"=>
      "/pcloud/v1/cloud-instances/bef6281afddd48668aa3cdf74fb12d41/pvm-instances/cee37e5b-ab8e-4edc-a0be-089a9eae0261/networks/public-192_168_130_104-29-VLAN_2073",
     "ip"=>"192.168.130.107",
     "ipAddress"=>"192.168.130.107",
     "macAddress"=>"fa:68:4d:3a:c5:20",
     "networkName"=>"public-192_168_130_104-29-VLAN_2073",
     "type"=>"fixed",
     "version"=>4}],
  "creationDate"=>"2020-04-13T19:43:21.000Z",
  "health"=>{"lastUpdate"=>"2020-04-20T19:02:00.859989", "status"=>"OK"},
  "href"=>
   "/pcloud/v1/cloud-instances/bef6281afddd48668aa3cdf74fb12d41/pvm-instances/cee37e5b-ab8e-4edc-a0be-089a9eae0261",
  "imageID"=>"86417217-375c-4c5b-be92-347372a87011",
  "networks"=>
   [{"href"=>
      "/pcloud/v1/cloud-instances/bef6281afddd48668aa3cdf74fb12d41/pvm-instances/cee37e5b-ab8e-4edc-a0be-089a9eae0261/networks/public-192_168_130_104-29-VLAN_2073",
     "ip"=>"192.168.130.107",
     "ipAddress"=>"192.168.130.107",
     "macAddress"=>"fa:68:4d:3a:c5:20",
     "networkName"=>"public-192_168_130_104-29-VLAN_2073",
     "type"=>"fixed",
     "version"=>4}],
  "pvmInstanceID"=>"cee37e5b-ab8e-4edc-a0be-089a9eae0261",
  "serverName"=>"jwcarman-tmp",
  "status"=>"ACTIVE",
  "sysType"=>"s922",
  "updatedDate"=>"2020-04-13T19:43:21.000Z"}]
{"addresses"=>
  [{"externalIP"=>"52.117.41.107",
    "href"=>
     "/pcloud/v1/cloud-instances/bef6281afddd48668aa3cdf74fb12d41/pvm-instances/cee37e5b-ab8e-4edc-a0be-089a9eae0261/networks/00235501-50ae-47fb-890f-55e900e79051",
    "ip"=>"192.168.130.107",
    "ipAddress"=>"192.168.130.107",
    "macAddress"=>"fa:68:4d:3a:c5:20",
    "networkID"=>"00235501-50ae-47fb-890f-55e900e79051",
    "networkName"=>"public-192_168_130_104-29-VLAN_2073",
    "type"=>"fixed",
    "version"=>4}],
 "creationDate"=>"2020-04-13T19:43:21.000Z",
 "diskSize"=>20,
 "health"=>{"lastUpdate"=>"2020-04-20T19:02:03.439198", "status"=>"OK"},
 "imageID"=>"86417217-375c-4c5b-be92-347372a87011",
 "maxmem"=>4,
 "maxproc"=>0.5,
 "memory"=>2,
 "migratable"=>false,
 "minmem"=>2,
 "minproc"=>0.25,
 "networkIDs"=>["00235501-50ae-47fb-890f-55e900e79051"],
 "networks"=>
  [{"externalIP"=>"52.117.41.107",
    "href"=>
     "/pcloud/v1/cloud-instances/bef6281afddd48668aa3cdf74fb12d41/pvm-instances/cee37e5b-ab8e-4edc-a0be-089a9eae0261/networks/00235501-50ae-47fb-890f-55e900e79051",
    "ip"=>"192.168.130.107",
    "ipAddress"=>"192.168.130.107",
    "macAddress"=>"fa:68:4d:3a:c5:20",
    "networkID"=>"00235501-50ae-47fb-890f-55e900e79051",
    "networkName"=>"public-192_168_130_104-29-VLAN_2073",
    "type"=>"fixed",
    "version"=>4}],
 "pinPolicy"=>"none",
 "procType"=>"capped",
 "processors"=>0.25,
 "pvmInstanceID"=>"cee37e5b-ab8e-4edc-a0be-089a9eae0261",
 "serverName"=>"jwcarman-tmp",
 "status"=>"ACTIVE",
 "storageType"=>"tier1",
 "sysType"=>"s922",
 "updatedDate"=>"2020-04-13T19:43:21.000Z",
 "volumeIDs"=>["4cc5b049-13fc-46ad-92e0-47c685b284a6"]}

  def parse
    vms
  end

  def vms
    persister_vmi = []

	# TODO: here loop over entries in the collector
	# find out how to access the collector
    VMIs.each do |vmi|
        persister_vmi << {
        :availability_zone => "",
        :description       => "IBM Power Server",
        :ems_ref           => vmi["pvmInstanceID"],
        :flavor            => "",
        :location          => "unknown",
        :name              => vmi["serverName"],
        :genealogy_parent  => "",
        :connection_state  => "connected",
        :raw_power_state   => vmi["status"],
        :uid_ems           => vmi["pvmInstanceID"],
        :vendor            => "VENDOR_IBM".freeze
        }
    end

	# TODO:here instead of the output persist the data
	# find out how to persist each 'vmi'
    puts persister_vmi
  end
	
end
