class ManageIQ::Providers::IbmCloudVirtualServers::ProvAPI
  require 'rest-client'
  require 'json'

  def initialize(creds)
    @creds  = creds
  end

  def provision_vmi(specs)
    response = RestClient.post(
        "https://#{@creds[:region]}.power-iaas.cloud.ibm.com/pcloud/v1/cloud-instances/#{@creds[:guid]}/pvm-instances",
        specs.to_json,
        'Authorization' => @creds[:token].get,
        'CRN'           => @creds[:crn],
        'Accept'        => 'application/json',
        'Content-Type'  => 'application/json',
    )

    JSON.parse(response.body)
  end

  def delete_vmi(token, guid, crn, region, vmi_id)
    response = RestClient.delete(
      "https://#{@creds[:region]}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{@creds[:guid]}/pvm-instances/#{vmi_id}",
      'Authorization' => @creds[:token].get,
      'CRN'           => @creds[:crn],
      'Accept'        => 'application/json',
    )
  end
end