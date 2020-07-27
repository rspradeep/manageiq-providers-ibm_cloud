class ManageIQ::Providers::IbmCloudVirtualServers::CloudControlAPI
  require 'rest-client'
  require 'json'

  include ManageIQ::Providers::IbmCloudVirtualServers::Config

  def initialize(creds)
    @creds  = creds
  end

  def del_network(network_id)
    response = RestClient.delete(
      IC_POWERVS_ENDPOINT.gsub("{region}", @creds[:region]) +
      "/pcloud/v1/cloud-instances/#{@creds[:guid]}/networks/#{network_id}",
      'Authorization' => @creds[:token].authorization_header,
      'CRN'           => @creds[:crn],
      'Accept'        => 'application/json'
    )

    JSON.parse(response.body)
  end

  def create_key_pair(name, sshkey)
    response = RestClient.post(
      IC_POWERVS_ENDPOINT.gsub("{region}", @creds[:region]) +
      "pcloud/v1/tenants/#{@creds[:tenant_id]}/sshkeys",
      {
        "name"   => name,
        "sshkey" => sshkey
      }.to_json,
      {
        'Authorization' => @creds[:token].authorization_header,
        'CRN'           => @creds[:crn],
        'Content-Type'  => 'application/json'
      }
    )
    JSON.parse(response.body)
  end

  def delete_key_pair(name)
    response = RestClient.delete(
      IC_POWERVS_ENDPOINT.gsub("{region}", @creds[:region]) +
      "pcloud/v1/tenants/#{@creds[:tenant_id]}/sshkeys/#{name}",
      headers={
        'Authorization' => @creds[:token].authorization_header,
        'CRN'           => @creds[:crn],
        'Content-Type'  => 'application/json'
      }
    )
    JSON.parse(response.body)
  end

  def del_image(image_id)
    response = RestClient.delete(
      IC_POWERVS_ENDPOINT.gsub("{region}", @creds[:region]) +
      "/pcloud/v1/cloud-instances/#{@creds[:guid]}/images/#{image_id}",
      'Authorization' => @creds[:token].authorization_header,
      'CRN'           => @creds[:crn],
      'Content-Type'  => 'application/json'
    )

    JSON.parse(response.body)
  end
end
