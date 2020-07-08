class ManageIQ::Providers::IbmCloudVirtualServers::CloudControlAPI
  require 'rest-client'
  require 'json'

  def initialize(creds)
    @creds  = creds
  end

  def del_network(network_id)
    response = RestClient.delete(
      "https://#{@creds[:region]}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{@creds[:guid]}/networks/#{network_id}",
      'Authorization' => @creds[:token].get,
      'CRN'           => @creds[:crn],
      'Accept'        => 'application/json'
    )

    JSON.parse(response.body)
  end

  def create_key_pair(nm)
    ibm_cvs_key = Struct.new(:name)
    ibm_cvs_key.new(nm)
  end
end
