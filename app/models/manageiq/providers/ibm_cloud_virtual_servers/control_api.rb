class ManageIQ::Providers::IbmCloudVirtualServers::ControlAPI
  require 'rest-client'
  require 'json'

  def initialize(creds)
    @creds  = creds
    @vmi_id = nil
  end

  def target_vmi(vmi_id)
    @vmi_id = vmi_id
    self
  end

  def power_on
    p "POWERING ON: " + @vmi_id if @vmi_id
    # TODO: implement
  end
  
  def power_off
    p "POWERING OFF: " + @vmi_id if @vmi_id
    # TODO: implement
  end
  
  def hard_reboot
    p "HARD REBOOTING: " + @vmi_id if @vmi_id
    # TODO: implement
  end

  def soft_reboot
    p "SOFT REBOOTING: " + @vmi_id if @vmi_id
    # TODO: implement
  end
end
