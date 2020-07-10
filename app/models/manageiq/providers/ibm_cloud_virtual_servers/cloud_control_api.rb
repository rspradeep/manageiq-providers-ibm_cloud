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

  def create_key_pair(name, sshkey)
    response = RestClient.post(
        "https://#{@creds[:region]}.power-iaas.cloud.ibm.com/" \
        "pcloud/v1/tenants/#{@creds[:tenant_id]}/sshkeys",
        {
          "name"   => name,
          "sshkey" => sshkey
        }.to_json,
        headers={
          'Authorization' => @creds[:token].get,
          'CRN'           => @creds[:crn],
          'Content-Type'  => 'application/json'
        }
      )
    JSON.parse(response.body)
  end

  def delete_key_pair(name)
      response = RestClient.delete(
        "https://#{@creds[:region]}.power-iaas.cloud.ibm.com/" \
        "pcloud/v1/tenants/#{@creds[:tenant_id]}/sshkeys/#{name}",
        headers={
          'Authorization' => @creds[:token].get,
          'CRN'           => @creds[:crn],
          'Content-Type'  => 'application/json'
        }
      )
     JSON.parse(response.body)
  end
end
