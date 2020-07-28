module ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Provision::Cloning
  def log_clone_options(clone_options)
    _log.info('ISG: LOGGING CLONE OPTIONS' + clone_options.inspect)
  end

  def prepare_for_clone_task
    specs = {
      'serverName' => get_option(:vm_name),
      'imageID'    => get_option_last(:src_vm_id),
      'processors' => get_option_last(:number_of_sockets),
      'procType'   => get_option_last(:instance_type),
      'memory'     => get_option_last(:vm_memory),
      'replicants' => get_option(:number_of_vms),
      'networks'   => [ {"networkID" => get_option(:vlan)} ]
    }
  end

  def start_clone(clone_options)
    source.with_provider_object({:target => 'provision'}) do |prov_api|
      prov_api.provision_vmi(clone_options)
    end
  end
  
  def do_clone_task_check(clone_task_ref)
    return false, 'Creation in process ...'
  end
end