class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::ProvisionWorkflow < ::MiqProvisionCloudWorkflow
  def get_timezones(_options = {})
  end

  def self.default_dialog_file
    'miq_provision_ibm_dialogs_template'
  end

  def allowed_instance_types(_options = {})
    []
  end

  def availability_zone_to_cloud_network(src)
    true
  end

  def allowed_security_groups(_options = {})
    []
  end

  def allowed_floating_ip_addresses(_options = {})
    []
  end

  def allowed_availability_zones(_options = {})
    []
  end

  def allowed_cloud_networks(_options = {})
    []
  end

  def allowed_cloud_subnets(_options = {})
    []
  end

  def allowed_number_of_vms(_options = {})
    []
  end

  def allowed_templates(_options = {})
    []
  end

  def allowed_guest_access_key_pairs(_options = {})
    []
  end

  private

  def security_group_to_availability_zones(src)
    []
  end

  def cloud_network_to_availability_zones(src)
    []
  end

  def cloud_subnet_to_availability_zones(src)
    []
  end

  def ip_available_for_selected_network?(ip, src)
    true
  end








  private

  def dialog_name_from_automate(message = 'get_dialog_name')
  end

  def self.provider_model
    ManageIQ::Providers::IbmCloudVirtualServers::CloudManager
  end
end