class ManageIQ::Providers::IbmCloudVirtualServers::Inventory::Parser::CloudManager < ManageIQ::Providers::Inventory::Parser
  def instances
    collector.vms.each do |instance|
      vmi =
        {
          :availability_zone => "",
          :description       => "IBM Cloud Server",
          :ems_ref           => instance["pvmInstanceID"],
          :flavor            => "",
          :location          => "unknown",
          :name              => instance["serverName"],
          :vendor            => 'ibm',
          :genealogy_parent  => "",
          :connection_state  => "connected",
          :raw_power_state   => instance["status"] == 'ACTIVE' ? 'on' : 'off',
          :uid_ems           => instance["pvmInstanceID"],
        }

      hardw =
        {
          :cpu_total_cores => Float(instance['processors']).ceil,
          :memory_mb       => Integer(instance['memory']) * 1024,
        }

      vol_ids  = instance['volumeIDs'] 

      img_id   = instance['imageID']

      pub_nets = instance['networks'].reject {|net| net['externalIP'].blank?}

      yield vmi, hardw, vol_ids, img_id, pub_nets
    end
  end


  def pub_img_os(img_id)
    image = collector.image(img_id)
    !image.nil? ? image['specifications']['operatingSystem'] : nil
  end

  def images
    collector.images.each do |ibm_image|
      id    = ibm_image['imageID']
      name  = ibm_image['name']

      os      = ibm_image['specifications']['operatingSystem']
      arch    = ibm_image['specifications']['architecture']
      endian  = ibm_image['specifications']['endianness']
      desc    = "System: #{os}, Architecture: #{arch}, Endianess: #{endian}"

      image =
      {
          :uid_ems            => id,
          :ems_ref            => id,
          :name               => name,
          :description        => desc,
          :location           => "unknown",
          :vendor             => "ibm",
          :connection_state   => "connected",
          :raw_power_state    => "never",
          :template           => true,
          :publicly_available => true,
      }

      yield image, os
    end
  end

  def volumes
    collector.volumes.each do |vol|s
      volume =
        {
          :ems_ref           => vol['volumeID'],
          :name              => vol['name'],
          :status            => vol['state'],
          :bootable          => vol['bootable'],
          :creation_time     => vol['creationDate'],
          :description       => 'IBM Cloud Block-Storage Volume',
          :volume_type       => vol['diskType'],
          :size              => vol['size'],
          :availability_zone => Zone.default_zone,
        }

      yield volume
    end
  end


  def parse
    img_to_os = {}

    images do |image, os|
      img_to_os[image[:ems_ref]] = os
      persister.miq_templates.build(image)
    end

    volumes do  |volume|
      ps_vol = persister.cloud_volumes.build(volume)
    end

    instances do |vmi, hardw, vol_ids, img_id, pub_ports|
      # saving general VMI information
      ps_vmi = persister.vms.build(vmi)

      # saving hardware information (CPU, Memory, etc.)
      hardw[:vm_or_template] = ps_vmi
      ps_hw = persister.hardwares.build(hardw)

      # saving instance disk information
      vol_ids.each do |vol_id|
        disk = persister.disks.find_or_build_by(
          :hardware    => ps_hw,
          :device_name => vol_id
        )
        
        disk.assign_attributes(
            :device_type     => 'block',
            :controller_type => 'ibm',
            :backing         => persister.cloud_volumes.find(vol_id),
            :location        => vol_id,
            :size            => 20)
      end

      # saving OS information
      os = img_to_os[img_id]
      os ||= pub_img_os(img_id)
      system = {:vm_or_template => ps_vmi, :product_name => os}
      persister.operating_systems.build(system)
    end
  end
end