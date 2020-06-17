require 'byebug'

class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::StorageManager < ManageIQ::Providers::Inventory::Parser
  def parse
    collector.volumes.each do |vol|
        volume =
        {
          :ems_ref => vol['volumeID'],
          :name => vol['name'],
          :status => vol['state'],
          :bootable => vol['bootable'],
          :creation_time => vol['creationDate'],
          :description => 'IBM Cloud Block-Storage Volume',
          :volume_type => vol['diskType'],
          :size => vol['size'],
          :availability_zone => Zone.default_zone,
      }

      persister.cloud_volumes.build(volume)
    end
  end
end