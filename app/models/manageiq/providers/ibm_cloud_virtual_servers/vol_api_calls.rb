module ManageIQ::Providers::IbmCloudVirtualServers::VolAPICalls
  require 'rest-client'
  require 'json'

  def get_volumes(token, guid, crn, region)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{guid}/volumes",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )
    volumes = []
    JSON.parse(response.body)['volumes'].each do |volume|
      volumes << get_volume(
        token, guid, crn, region, volume['volumeID']
      )
    end
    volumes
  end

  def get_volume(token, guid, crn, region, volume_id)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{guid}/volumes/#{volume_id}",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )
    JSON.parse(response.body)
  end
end
