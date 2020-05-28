class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Vm < ManageIQ::Providers::CloudManager::Vm
  supports     :reboot_guest
  supports_not :suspend
  
  def provider_object(connection = nil)
    connection.target_vmi(ems_ref)
  end

  def raw_start
    with_provider_object({:target => 'control'}, &:power_on)
    update!(:raw_power_state => "on")
  end

  def raw_stop
    with_provider_object({:target => 'control'}, &:power_off)
    update!(:raw_power_state => "off")
  end

  def raw_reboot_guest
    with_provider_object({:target => 'control'}, &:soft_reboot)
    update!(:raw_power_state => "off")
  end

  def self.calculate_power_state(raw_power_state)
    raw_power_state
  end
end