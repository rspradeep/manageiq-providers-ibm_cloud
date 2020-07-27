class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Provision < MiqProvision
  include_concern 'Cloning'
  include_concern 'StateMachine'
end
