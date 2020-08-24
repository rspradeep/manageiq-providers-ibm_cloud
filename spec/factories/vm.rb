FactoryBot.define do
  factory :vm_ibm_cloud_powervs, :class => "ManageIQ::Providers::vm_ibm_cloud_powervs::CloudManager::Vm", :parent => :vm_ibm_cloud_powervs do
    location        { |x| "[storage] #{x.name}/#{x.name}.vmx" }
    vendor          { "vm_ibm_cloud_powervs" }
    raw_power_state { "poweredOn" }
  end
end
