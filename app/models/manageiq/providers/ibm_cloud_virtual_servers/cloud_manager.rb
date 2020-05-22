class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager < ManageIQ::Providers::CloudManager
  require_nested :MetricsCapture
  require_nested :MetricsCollectorWorker
  require_nested :Refresher
  require_nested :RefreshWorker
  require_nested :Template
  require_nested :Vm

  include ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin

  before_create :ensure_managers
  before_create :ensure_managers_zone

  def ensure_managers
    ensure_managers_zone
    ensure_network_manager
  end

  def ensure_managers_zone
    network_manager.zone_id = zone_id if network_manager
  end

  def ensure_network_manager
    build_network_manager(:type => 'ManageIQ::Providers::IbmCloudVirtualServers::NetworkManager') unless network_manager
  end

  def self.validate_authentication_args(params)
    # return args to be used in raw_connect
    [params[:default_userid], ManageIQ::Password.encrypt(params[:default_password])]
  end

  def self.hostname_required?
    # TODO: ExtManagementSystem is validating this
    false
  end

  def self.ems_type
    @ems_type ||= "ibm_cloud_virtual_servers".freeze
  end

  def self.description
    @description ||= "Ibm Cloud Virtual Servers".freeze
  end
end
