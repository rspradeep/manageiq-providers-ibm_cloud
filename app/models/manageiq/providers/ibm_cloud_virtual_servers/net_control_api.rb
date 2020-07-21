require 'byebug'

class ManageIQ::Providers::IbmCloudVirtualServers::NetControlAPI
  require 'rest-client'
  require 'json'

  def initialize(creds)
    @creds  = creds
  end

  def del_subnet(network_id)
    response = RestClient.delete(
      "https://#{@creds[:region]}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{@creds[:guid]}/networks/#{network_id}",
      'Authorization' => @creds[:token].get,
      'CRN'           => @creds[:crn],
      'Accept'        => 'application/json',
    )

    JSON.parse(response.body)
  end


  def create_subnet(subnet)
    response = RestClient.post(
      "https://#{@creds[:region]}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{@creds[:guid]}/networks",
      subnet.to_json,
      'Authorization' => @creds[:token].get,
      'CRN'           => @creds[:crn],
      'Accept'        => 'application/json',
      'Content-Type'  => 'application/json',
    )

    JSON.parse(response.body)
  end
end
