class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Vm < ManageIQ::Providers::CloudManager::Vm
  def provider_object(connection = nil)
    connection.target_vmi(ems_ref)
  end

  def raw_start
    with_provider_object({:target => 'control'}, &:power_on)
    # Temporarily update state for quick UI response until refresh comes along
    update!(:raw_power_state => "on")
  end

  def raw_stop
    with_provider_object({:target => 'control'}, &:power_off)
    # Temporarily update state for quick UI response until refresh comes along
    update!(:raw_power_state => "off")
  end

  def raw_pause
    # Temporarily update state for quick UI response until refresh comes along
    update!(:raw_power_state => "paused")
  end

  def raw_suspend
    # Temporarily update state for quick UI response until refresh comes along
    update!(:raw_power_state => "suspended")
  end

  # TODO: this method could be the default in a baseclass
  def self.calculate_power_state(raw_power_state)
    # do some mapping on powerstates
    # POWER_STATES[raw_power_state.to_s] || "terminated"
    raw_power_state
  end
end
