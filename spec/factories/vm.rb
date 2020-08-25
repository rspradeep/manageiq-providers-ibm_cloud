FactoryBot.define do
  factory :vm_ibm_cloud_powervs, :class => "ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm", :parent => :ems_ibm_cloud_power_virtual_servers_cloud do
    location        { |x| "[storage] #{x.name}/#{x.name}.vmx" }
    vendor          { "vm_Ibm_Cloud_Powervs" }
    raw_power_state { "poweredOn" }
  end
end
