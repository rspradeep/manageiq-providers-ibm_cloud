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
    p "POWERING ON: #{@vmi_id}"
    cloudVmiAction(:start)
  end
  
  def power_off
    p "POWERING OFF: #{@vmi_id}"
    cloudVmiAction(:stop)
  end
  
  def hard_reboot
    cloudVmiAction(:hard_reboot)
  end

  def soft_reboot
    cloudVmiAction(:soft_reboot)
  end

  private

  def cloudVmiAction(action)
    begin
      response = RestClient.post(
        "https://#{@creds[:region]}.power-iaas.cloud.ibm.com/pcloud/v1/cloud-instances/#{@creds[:guid]}/pvm-instances/#{@vmi_id}/action",
        
        {
          'action' => action 
        }
        .to_json,

        {
          'Authorization' => @creds[:token].get,
          'CRN'           => @creds[:crn],
          'Content-Type'  => 'application/json',
          'Accept'        => 'application/json',
        },
      )
    rescue RestClient::ExceptionWithResponse => e
      e.response unless e.http_code == 200
    end
  end
end