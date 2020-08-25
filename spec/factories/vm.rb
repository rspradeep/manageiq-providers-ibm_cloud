FactoryBot.define do
  factory :vm_Ibm_Cloud_Powervs, :class => "ManageIQ::Providers::vm_Ibm_Cloud_Powervs::CloudManager::Vm", :parent => :vm_Ibm_Cloud_Powervs do
    location        { |x| "[storage] #{x.name}/#{x.name}.vmx" }
    vendor          { "vm_Ibm_Cloud_Powervs" }
    raw_power_state { "poweredOn" }
  end
end
