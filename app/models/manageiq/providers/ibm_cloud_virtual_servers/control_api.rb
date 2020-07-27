class ManageIQ::Providers::IbmCloudVirtualServers::ControlAPI
  require 'rest-client'
  require 'json'

  include ManageIQ::Providers::IbmCloudVirtualServers::Config

  def initialize(creds)
    @creds  = creds
    @vmi_id = nil
  end

  def target_vmi(vmi_id)
    @vmi_id = vmi_id
    self
  end

  def power_on
    _log.info("POWERING ON: #{@vmi_id}")
    cloud_vmi_action(:start)
  end

  def power_off
    _log.info("POWERING OFF: #{@vmi_id}")
    cloud_vmi_action(:stop)
  end

  def soft_reboot
    _log.info("REBOOTING OS FOR: #{@vmi_id}")
    cloud_vmi_action(:'soft-reboot')
  end

  private

  def cloud_vmi_action(action)
    RestClient.post(
      IC_POWERVS_ENDPOINT.gsub("{region}", @creds[:region]) +
      "/pcloud/v1/cloud-instances/#{@creds[:guid]}/pvm-instances/#{@vmi_id}/action",
      {
        'action' => action
      }
      .to_json,
      'Authorization' => @creds[:token].authorization_header,
      'CRN'           => @creds[:crn],
      'Content-Type'  => 'application/json',
      'Accept'        => 'application/json'
    )
  rescue RestClient::ExceptionWithResponse => e
    e.response.body unless e.http_code == 200
  end
end
