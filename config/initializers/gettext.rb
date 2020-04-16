Vmdb::Gettext::Domains.add_domain(
  'ManageIQ::Providers::IbmCloudVirtualServers',
  ManageIQ::Providers::IbmCloudVirtualServers::Engine.root.join('locale').to_s,
  :po
)
