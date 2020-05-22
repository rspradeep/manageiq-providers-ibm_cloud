module ManageIQ::Providers::IbmCloudVirtualServers::APICalls
  require 'rest-client'
  require 'json'

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
        "https://iam.cloud.ibm.com/identity/token",
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
      "https://resource-controller.cloud.ibm.com" \
      "/v2/resource_instances",
      'Authorization' => token.get
    )
    resource_list = JSON.parse(response.body)['resources']
    resource = resource_list.detect { |res| res['guid'] == guid }
    return resource['crn'], resource['region_id']
  end

  # Get all PVM instances in an IBM Power Cloud instance
  #
  # @param token [IAMtoken] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @return [Array<Hash>] all PVM Instances for this instance
  def get_pcloudpvminstances(token, guid, crn, region)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{guid}/pvm-instances",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )
    instances = []
    JSON.parse(response.body)['pvmInstances'].each do |instance|
      instances << get_pcloudpvminstance(
        token, guid, crn, region, instance['pvmInstanceID']
      )
    end
    instances
  end

  # Get an IBM Power Cloud PVM instance
  #
  # @param token [IAMtoken] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @param pvm_instance_id [String] the PVM instance ID
  # @return [Hash] PVM Instances
  def get_pcloudpvminstance(token, guid, crn, region, pvm_instance_id)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{guid}/pvm-instances/#{pvm_instance_id}",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )
    JSON.parse(response.body)
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
      "https://#{region}.power-iaas.cloud.ibm.com" \
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
      "https://#{region}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{guid}/networks/#{network_id}",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )
    JSON.parse(response.body)
  end

  # Get all images in an IBM Power Cloud instance
  #
  # @param token [IAMtoken] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @return [Array<Hash>] all Images for this instance
  def get_images(token, guid, crn, region)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{guid}/images",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )

    images = []
    JSON.parse(response.body)['images'].each do |image|
      images << get_image(
        token, guid, crn, region, image['imageID']
      )
    end
    images
  end

  # Get an IBM Power Cloud image
  #
  # @param token [IAMtoken] the IBM Cloud IAM Token object
  # @param guid [String] the IBM Power Cloud instance GUID
  # @param crn [String] the IBM Power Cloud instance CRN
  # @param region [String] the IBM Power Cloud instance region
  # @return [Hash] Image
  def get_image(token, guid, crn, region, imageid)
    response = RestClient.get(
      "https://#{region}.power-iaas.cloud.ibm.com" \
      "/pcloud/v1/cloud-instances/#{guid}/images/#{imageid}",
      'Authorization' => token.get,
      'CRN'           => crn,
      'Content-Type'  => 'application/json'
    )

    JSON.parse(response.body)
  end
end
