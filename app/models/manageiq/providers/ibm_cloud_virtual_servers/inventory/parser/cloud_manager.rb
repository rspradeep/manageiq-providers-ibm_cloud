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

      img_id = instance['imageID']

      yield vmi, hardw, img_id
    end
  end

  def pub_img_os(img_id)
    image = collector.image(img_id)
    os = (image != nil) ? image['specifications']['operatingSystem'] : nil
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

  def sshkeys
    collector.sshkeys.each do |keyindx|
      tenant_name = keyindx[:tenant_name]
      tenant_id   = keyindx[:tenant_id]
      keyindx[:tenant_sshkeys].each do |tkey|
        tenant_key =
        {
          :name     => tkey['name'],
          :auth_key => tkey['sshKey'],
        }
        yield tenant_key
      end
    end
  end

  def parse
    img_to_os = {}

    images do |image, os|
      img_to_os[image[:ems_ref]] = os
      persister.miq_templates.build(image)
    end

    instances do |vmi, hardw, img_id|
      # saving general VMI information
      ps_vmi = persister.vms.build(vmi)

      # saving hardware information (CPU, Memory, etc.)
      hardw[:vm_or_template] = ps_vmi
      persister.hardwares.build(hardw)

      # saving OS information
      os = img_to_os[img_id]
      os ||= pub_img_os(img_id)
      system = {:vm_or_template => ps_vmi, :product_name => os}
      persister.operating_systems.build(system)
    end

    sshkeys do |tenant_key|
      # save the tenant instance
      persister.key_pairs.build(tenant_key)
    end
  end
end
