class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager < ManageIQ::Providers::CloudManager
  require_nested :AuthKeyPair
  require_nested :MetricsCapture
  require_nested :MetricsCollectorWorker
  require_nested :Refresher
  require_nested :RefreshWorker
  require_nested :Provision
  require_nested :ProvisionWorkflow
  require_nested :Template
  require_nested :Vm

  include ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin

  has_one :storage_manager,
          :foreign_key => :parent_ems_id,
          :class_name  => "ManageIQ::Providers::IbmCloudVirtualServers::StorageManager",
          :autosave    => true,
          :dependent   => :destroy

  before_create :ensure_managers
  before_create :ensure_managers_zone

  supports :provisioning

  def ensure_managers
    ensure_managers_zone
    ensure_network_manager
    ensure_storage_manager
  end

  def ensure_managers_zone
    network_manager.zone_id = zone_id if network_manager
    storage_manager.zone_id = zone_id if storage_manager
  end

  def ensure_network_manager
    build_network_manager(:type => 'ManageIQ::Providers::IbmCloudVirtualServers::NetworkManager') unless network_manager
    network_manager.name = "Network-Manager of '#{name}'"
  end

  def ensure_storage_manager
    build_storage_manager unless storage_manager
    storage_manager.name = "Storage-Manager of '#{name}'"
  end

  def self.hostname_required?
    # TODO: ExtManagementSystem is validating this
    false
  end

  def self.ems_type
    @ems_type ||= IC_SERVICE_DESC_NOSPACES.freeze
  end

  def self.description
    @description ||= IC_SERVICE_DESC.freeze
  end
end