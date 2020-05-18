module ManageIQ::Providers::IbmCloudVirtualServers::NetAPICalls
require 'rest-client'
require 'json'

  class IAM_Token
    # Generic IBM Cloud IAM Token Class
    # @param api_key [String] the IBM Cloud API key
    def initialize(api_key)
      @api_key = api_key
      @token = update_token
    end

    # Retrieve access_token to be used in as 'Authorization' header value
    # @todo Add check/update logic to determine if current token is
    #   or needs to be refreshed.
    # @return [String] the access token formatted with type prefix
    def get
      return "%s %s" % [@token['token_type'], @token['access_token']]
    end

    private
    # Update access token. Token is valid for one hour.
    def update_token
      response = RestClient.post(
        "https://iam.cloud.ibm.com/identity/token",
        { 'grant_type' => 'urn:ibm:params:oauth:grant-type:apikey',
          'apikey' => @api_key },
        { 'Content-Type' => 'application/x-www-form-urlencoded',
          'Accept' => 'application/json'}
      )
      return JSON.parse(response.body)
    end
  end

  # Retrieve an IBM Cloud service's CRN and region
  #
  # @param api_key [String] the IBM Cloud API key
  # @return [Array<String>] the associated crn, region
  def get_service_crn_region(token, guid)
    response = RestClient.get(
      "https://resource-controller.cloud.ibm.com" +
      "/v2/resource_instances",
      { 'Authorization' => token.get() }
    )
    resource_list = JSON.parse(response.body)['resources']
    resource = resource_list.detect{ |resource| resource['guid'] == guid }
    return resource['crn'], resource['region_id']
  end

  # Get network ports for this network id in IBM Power Cloud
  #
  # @param token [IAM_Token] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @param network_id [String] the network ID
  # @return [Array<Hash>] all networks for this IBM Power Cloud instance
  def get_ports(token, guid, crn, region, network_id)
	response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" + "/pcloud/v1/cloud-instances/#{guid}/networks/#{network_id}/ports",
      { 'Authorization' => token.get(),
        'CRN' => crn,
        'Content-Type' => 'application/json' 
	  }
    )

    JSON.parse(response.body)['ports']
  end
 
  # Get all networks in an IBM Power Cloud instance
  #
  # @param token [IAM_Token] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @return [Array<Hash>] all networks for this IBM Power Cloud instance
  def get_networks(token, guid, crn, region)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" +
      "/pcloud/v1/cloud-instances/#{guid}/networks",
      { 'Authorization' => token.get(),
        'CRN' => crn,
        'Content-Type' => 'application/json' }
    )
    networks = Array.new
    JSON.parse(response.body)['networks'].each do |network|
      networks << get_network(
        token, guid, crn, region, network['networkID'])
    end
    return networks
  end

  # Get an IBM Power Cloud network
  #
  # @param token [IAM_Token] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @param network_id [String] the network ID
  # @return [Hash] Network
  def get_network(token, guid, crn, region, network_id)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" +
      "/pcloud/v1/cloud-instances/#{guid}/networks/#{network_id}",
      { 'Authorization' => token.get(),
        'CRN' => crn,
        'Content-Type' => 'application/json' }
    )
    return JSON.parse(response.body)
  end

end