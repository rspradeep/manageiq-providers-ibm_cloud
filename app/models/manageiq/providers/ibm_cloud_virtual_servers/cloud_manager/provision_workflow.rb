class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::ProvisionWorkflow < ::MiqProvisionCloudWorkflow

  SYSPREP_TIMEZONES = {
    '003' => '(UTC-10:00) Hawaiian Standard Time',
    '004' => '(UTC-09:00) Alaskan Standard Time',
    '005' => '(UTC-08:00) Pacific Standard Time',
    '006' => '(UTC-07:00) US Mountain Standard Time',
    '057' => '(UTC+04:00) Azerbaijan Standard Time',
  }.freeze

  def get_timezones(_options = {})
    SYSPREP_TIMEZONES
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
    a = *(1..10)
    Hash[a.zip(a.map(&:to_s))]
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