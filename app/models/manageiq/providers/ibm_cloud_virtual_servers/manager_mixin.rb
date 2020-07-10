module ManageIQ::Providers::IbmCloudVirtualServers::ManagerMixin
  extend ActiveSupport::Concern

  def required_credential_fields(_type)
    [:auth_key]
  end

  def supported_auth_attributes
    %w[auth_key]
  end

  def connect(options = {})
    auth_key = authentication_key(options[:auth_type])
    creds = self.class.raw_connect(auth_key, uid_ems)
    api = nil

    begin
      case options[:target]
      when 'cloud'
        creds[:tenant_id] = self.class.raw_tenant_id(creds)
        api = ManageIQ::Providers::IbmCloudVirtualServers::CloudControlAPI.new(creds)
      when 'network'
        api = ManageIQ::Providers::IbmCloudVirtualServers::NetControlAPI.new(creds)
      when 'control'
        api = ManageIQ::Providers::IbmCloudVirtualServers::ControlAPI.new(creds)
      when nil, {}
        api = ManageIQ::Providers::IbmCloudVirtualServers::CloudControlAPI.new(creds)
      else
        raise ArgumentError, "Unknown target API set: '#{options[:target]}''"
      end
    end

    api
  end

  def verify_credentials(_auth_type = nil, options = {})
    connect(options)
    true
  end

  module ClassMethods
    def params_for_create
      @params_for_create ||= {
        :fields => [
          {
            :component  => "text-field",
            :name       => "uid_ems",
            :label      => _("PowerVS Service GUID"),
            :isRequired => true,
            :validate   => [{:type => "required-validator"}],
          },
          {
            :component  => "password-field",
            :name       => "authentications.default.auth_key",
            :label      => _("IBM Cloud API Key"),
            :type       => "password",
            :isRequired => true,
            :validate   => [{:type => "required-validator"}]
          },
        ],
      }.freeze
    end

    # Verify Credentials
    # args:
    # {
    #   "uid_ems"         => "",
    #   "authentications" => {
    #     "default" => {
    #       "auth_key" => "",
    #     }
    #   }
    # }
    def verify_credentials(args)
      pcloud_guid = args["uid_ems"]
      auth_key = args.dig("authentications", "default", "auth_key")
      auth_key = MiqPassword.try_decrypt(auth_key)
      auth_key ||= find(args["id"]).authentication_token('default')

      !!raw_connect(auth_key, pcloud_guid)
    end

    include ManageIQ::Providers::IbmCloudVirtualServers::APICalls
    def raw_connect(api_key, pcloud_guid)
      if api_key.blank? || pcloud_guid.blank?
        raise MiqException::MiqInvalidCredentialsError, _("Missing credentials")
      end

      token = IAMtoken.new(api_key)
      crn, region = get_service_crn_region(token, pcloud_guid)
      
      {:token => token, :guid => pcloud_guid, :crn => crn, :region => region}
    end

    def raw_tenant_id(creds)
      plst = get_pvstenantid(creds[:token])
      _log.info("The tenant id=[%s]"%[plst[0][:tenant_id]])
      plst[0][:tenant_id]
    end


    def api_rescue_block
      _log.info("rescue")
    end

    def environment_for(region)
      case region
      when /germany/i
        _log.info("germ")
      when /usgov/i
        _log.info("usa")
      else
        _log.info("else country")
      end
    end
  end
end
