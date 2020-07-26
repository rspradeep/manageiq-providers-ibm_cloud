module ManageIQ::Providers::IbmCloudVirtualServers::NetAPICalls
  require 'rest-client'
  require 'json'

  include ManageIQ::Providers::IbmCloudVirtualServers::Config

  class IAMtoken
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
      "#{@token['token_type']} #{@token['access_token']}"
    end

    private

    # Update access token. Token is valid for one hour.
    def update_token
      response = RestClient.post(
        IC_IAM_ENDPOINT + "/identity/token",
        {'grant_type' => 'urn:ibm:params:oauth:grant-type:apikey',
         'apikey'     => @api_key},
        {'Content-Type' => 'application/x-www-form-urlencoded',
         'Accept'       => 'application/json'}
      )
      JSON.parse(response.body)
    end
  end

  # Retrieve an IBM Cloud service's CRN and region
  #
  # @param api_key [String] the IBM Cloud API key
  # @return [Array<String>] the associated crn, region
  def get_service_crn_region(token, guid)
    response = RestClient.get(
      IC_RESOURCE_CONT_ENDPOINT + "/v2/resource_instances",
      'Authorization' => token.get
    )
    resource_list = JSON.parse(response.body)['resources']
    resource = resource_list.detect { |res| res['guid'] == guid }
    return resource['crn'], resource['region_id']
  end

  # Get network ports for this network id in IBM Power Cloud
  #
  # @param token [IAMtoken] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @param network_id [String] the network ID
  # @return [Array<Hash>] all networks for this IBM Power Cloud instance
  def get_ports(token, guid, crn, region, network_id)
    response = RestClient.get(
      IC_POWERVS_ENDPOINT.gsub("{region}", region) +
      "/pcloud/v1/cloud-instances/#{guid}/networks/#{network_id}/ports",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )

    JSON.parse(response.body)['ports']
  end

  # Get all networks in an IBM Power Cloud instance
  #
  # @param token [IAMtoken] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @return [Array<Hash>] all networks for this IBM Power Cloud instance
  def get_networks(token, guid, crn, region)
    response = RestClient.get(
      IC_POWERVS_ENDPOINT.gsub("{region}", region) +
      "/pcloud/v1/cloud-instances/#{guid}/networks",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )
    networks = []
    JSON.parse(response.body)['networks'].each do |network|
      networks << get_network(
        token, guid, crn, region, network['networkID']
      )
    end
    networks
  end

  # Get an IBM Power Cloud network
  #
  # @param token [IAMtoken] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @param network_id [String] the network ID
  # @return [Hash] Network
  def get_network(token, guid, crn, region, network_id)
    response = RestClient.get(
      IC_POWERVS_ENDPOINT.gsub("{region}", region) +
      "/pcloud/v1/cloud-instances/#{guid}/networks/#{network_id}",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )
    JSON.parse(response.body)
  end
end
