module ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Provision::Cloning
  def log_clone_options(clone_options)
    _log.info('ISG: LOGGING CLONE OPTIONS' + clone_options.inspect)
  end

  def prepare_for_clone_task
    {
      'serverName' => get_option(:vm_name),
      'imageID'    => get_option_last(:src_vm_id),
      'processors' => get_option_last(:number_of_sockets),
      'procType'   => get_option_last(:instance_type),
      'memory'     => get_option_last(:vm_memory),
      'replicants' => get_option(:number_of_vms),
      'networks'   => [{"networkID" => get_option(:vlan)}]
    }
  end

  def start_clone(clone_options)
    source.with_provider_object({:service => "PowerIaas"}) do |power_iaas|
      power_iaas.create_pvm_instance(clone_options)
    end
  end

  def do_clone_task_check(_clone_task_ref)
    return false, 'Creation in process ...'
  end
end
