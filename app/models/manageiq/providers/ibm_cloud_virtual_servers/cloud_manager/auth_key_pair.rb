require "byebug"

class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::AuthKeyPair < ManageIQ::Providers::CloudManager::AuthKeyPair
  IbmCvsKeyPair = Struct.new(:name, :key_name, :fingerprint, :private_key)

  def self.raw_create_key_pair(ext_management_system, create_options)
    _log.info("KNKN= This is the ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::AuthKeyPair::self.raw_create_key_pair\n")
    _log.info(create_options)
    cvs = ext_management_system.connect(:target => "cloud")
    kp = cvs.create_key_pair(create_options[:name])
    _log.info("KNKN= After making rest api call")
    _log.info(kp)
    IbmCvsKeyPair.new(kp.name, kp.name, nil, nil)
  rescue => err
    _log.error "keypair=[#{name}], error: #{err}"
    raise MiqException::Error, err.to_s, err.backtrace
  end

  def self.validate_create_key_pair(ext_management_system, _options = {})
    _log.info("KNKN= This is the ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::AuthKeyPair::self.validate_create_key_pair")
    if ext_management_system
      {:available => true, :message => nil}
    else
      {:available => false,
       :message   => _("The Keypair is not connected to an active %{table}") %
         {:table => ui_lookup(:table => "ext_management_system")}}
    end
  end

  def raw_delete_key_pair
    _log.info("KNKN= This is the ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::AuthKeyPair::self.raw_delete_key_pair")
    cvs = resource.connect
    kp = cvs.key_pair(name)
    kp.delete
  rescue => err
    _log.error "keypair=[#{name}], error: #{err}"
    raise MiqException::Error, err.to_s, err.backtrace
  end

  def validate_delete_key_pair
    _log.info("KNKN= This is the ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::AuthKeyPair::self.validate_delete_key_pair")
    {:available => true, :message => nil}
  end
end
