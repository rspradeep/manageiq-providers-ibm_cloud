module ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin
  extend ActiveSupport::Concern

  def required_credential_fields(_type)
    [:auth_key]
  end

  def supported_auth_attributes
    %w[userid password auth_key]
  end

  def connect(options = {})
    self.class.raw_connect('y5yBMMyXXgKjDMKk7uuT_heaA674iW3LW4XF0koEldQI', '473f85b4-c4ba-4425-b495-d26c77365c91')
  end

  def verify_credentials(_auth_type = nil, options = {})
    connect(options)
  end

  module ClassMethods
    include ManageIQ::Providers::IbmCloudVirtualServers::APICalls
    def raw_connect(api_key, guid)
      if api_key.blank? || guid.blank?
        raise MiqException::MiqInvalidCredentialsError, _("Incorrect credentials - check your Azure Subscription ID")
      end
      token = IAM_Token.new(api_key)
      crn, region = self.get_service_crn_region(token, guid)
      return {:token => token, :guid => guid, :crn => crn, :region => region}
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
