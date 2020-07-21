module ManageIQ::Providers::IbmCloud::PowerVirtualServers::Config
  IC_SERVICE_DESC = "IBM Cloud Power Systems Virtual Server".freeze
  IC_SERVICE_DESC_NOSPACES = "ibm_cloud_power_virtual_servers".freeze # used for image file prefixes

  # IBM Cloud IAM Identity Services API Endpoint URL
  # https://cloud.ibm.com/apidocs/iam-identity-token-api
  IC_IAM_ENDPOINT = "https://iam.cloud.ibm.com".freeze

  # IBM Cloud Resource Controller API Endpoint URL
  IC_RESOURCE_CONT_ENDPOINT = "https://resource-controller.cloud.ibm.com".freeze

  # IBM Cloud Power Systems Virtual Server API Endpoint URL
  # Note: The "{region}" substring will be replaced by region found by
  #       resource controller lookup. A static URL can be set by
  #       omitting "{region}".
  IC_POWERVS_ENDPOINT = "https://{region}.power-iaas.cloud.ibm.com".freeze
end
