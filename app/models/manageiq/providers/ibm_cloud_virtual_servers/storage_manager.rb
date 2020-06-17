class ManageIQ::Providers::IbmCloudVirtualServers::StorageManager < ManageIQ::Providers::StorageManager
  require_nested :CloudVolume
  require_nested :Refresher

  include ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin
  include ManageIQ::Providers::StorageManager::BlockMixin

  def self.ems_type
    @ems_type ||= "ibm_cloud_storage".freeze
  end

  def self.description
    @description ||= "IBM Cloud Storage".freeze
  end

  def self.hostname_required?
    false
  end
end