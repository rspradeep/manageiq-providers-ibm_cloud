module ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin
  extend ActiveSupport::Concern

  def required_credential_fields(_type)
    [:auth_key]
  end

  def supported_auth_attributes
    %w[userid password auth_key]
  end

  def connect(options = {})
    self.class.raw_connect(authentication_token(options[:api_key], options[:guid]))
  end

  def verify_credentials(_auth_type = nil, options = {})
    connect(options)
  end

  module ClassMethods
    def raw_connect(api_key, guid)
      if api_key.blank? || guid.blank?
        raise MiqException::MiqInvalidCredentialsError, _("Incorrect credentials - check your Azure Subscription ID")
      end
      include ManageIQ::Providers::IbmCloudVirtualServers::APICalls
      token = ManageIQ::Providers::IbmCloudVirtualServers::APICalls::IAM_Token.new(api_key)
      return token, guid
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
