class ManageIQ::Providers::IbmCloudVirtualServers::NetworkManager < ManageIQ::Providers::NetworkManager
  require_nested :Refresher
  require_nested :RefreshWorker
  require_nested :CloudNetwork
  require_nested :CloudSubnet
  require_nested :NetworkPort

  include ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin

  def self.validate_authentication_args(params)
    # return args to be used in raw_connect
    [params[:default_userid], ManageIQ::Password.encrypt(params[:default_password])]
  end

  def self.hostname_required?
    # TODO: ExtManagementSystem is validating this
    false
  end

  def self.ems_type
    @ems_type ||= "ibm_cloud_networks".freeze
  end

  def self.description
    @description ||= "IBM Cloud Networks".freeze
  end
end