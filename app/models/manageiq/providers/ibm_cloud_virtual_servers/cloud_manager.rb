class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager < ManageIQ::Providers::CloudManager
  require_nested :MetricsCapture
  require_nested :MetricsCollectorWorker
  require_nested :Refresher
  require_nested :RefreshWorker
  require_nested :Vm
  
  include ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin 


  def self.validate_authentication_args(params)
    # return args to be used in raw_connect
    return [params[:default_userid], ManageIQ::Password.encrypt(params[:default_password])]
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
