describe ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::Refresher do
  it ".ems_type" do
    expect(described_class.ems_type).to eq(:ibm_cloud_virtual_servers)
  end

  context "#refresh" do
    let(:ems) do
      uid_ems  = "473f85b4-c4ba-4425-b495-d26c77365c91"
      auth_key = Rails.application.secrets.ibmcvs.try(:[], :api_key) || "IBMCVS_API_KEY"

      FactoryBot.create(:ems_ibm_cloud_virtual_servers_cloud, :uid_ems => uid_ems, :provider_region => "us-south").tap do |ems|
        ems.authentications << FactoryBot.create(:authentication, :auth_key => auth_key)
      end
    end

    it "full refresh" do
      2.times do
        full_refresh(ems)
        ems.reload

        assert_table_counts
      end
    end

    def assert_table_counts
    end

    def full_refresh(ems)
      VCR.use_cassette(described_class.name.underscore) do
        EmsRefresh.refresh(ems)
      end
    end
  end
end
