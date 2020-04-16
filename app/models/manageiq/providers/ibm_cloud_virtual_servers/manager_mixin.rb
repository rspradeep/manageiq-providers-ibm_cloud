module ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin
  extend ActiveSupport::Concern

  def connect(options = {})
    self.class.raw_connect(authentication_token(options[:auth_type]), "client_key","test")
  end

  def verify_credentials(_auth_type = nil, options = {})
    connect(options)
  end


  module ClassMethods
  
    def raw_connect(api_key, guid, region)
      if api_key.blank? || guid.blank?
        raise MiqException::MiqInvalidCredentialsError, _("Incorrect credentials - check your Azure Subscription ID")
      end
      require 'net/http'
      require 'rest-client'
      require 'json'
      # add rest api gem
      my_api_key = 'y5yBMMyXXgKjDMKk7uuT_heaA674iW3LW4XF0koEldQI'
      my_pcloud_guid = '473f85b4-c4ba-4425-b495-d26c77365c91'
      my_region = 'us-south'
      response = RestClient.post(
        "https://iam.cloud.ibm.com/identity/token",
        { 'grant_type' => 'urn:ibm:params:oauth:grant-type:apikey',
          'apikey' => my_api_key },
        { 'Content-Type' => 'application/x-www-form-urlencoded',
          'Accept' => 'application/json'}
    )
      JSON.parse(response.body)
    
    end

    def connection_rescue_block
      print "rescue"
    end

    def environment_for(region)
      case region
      when /germany/i
        print "germ"
      when /usgov/i
        print "usa"
      else
        print "else country"
      end
    end
  end
end
