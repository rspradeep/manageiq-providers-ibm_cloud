describe ManageIQ::Providers::IbmCloud::PowerVirtualServers::CloudManager::Vm do
  let(:ems) do                                                                                                                                                               
    uid_ems  = "473f85b4-c4ba-4425-b495-d26c77365c91"                                                                                                                        
    auth_key = Rails.application.secrets.ibmcvs.try(:[], :api_key) || "IBMCVS_API_KEY"                                                                                       
    FactoryBot.create(:ems_ibm_cloud_powervs, :uid_ems => uid_ems, :provider_region => "us-south").tap do |ems|                                          
      ems.authentications << FactoryBot.create(:authentication, :auth_key => auth_key)                                                                                       
    end                                                                                                                                                                      
  end                                                                                                                                                                        
  let(:vm)  { FactoryBot.create(:vm_ibm_cloud_powervs, :ext_management_system => ems) }

  context "#is_available?" do
    let(:power_state_on)        { "running" }
    let(:power_state_suspended) { "pending" }

    context("with :start") do
      let(:state) { :start }
      include_examples "Vm operation is available when not powered on"
    end

    context("with :stop") do
      let(:state) { :stop }
      include_examples "Vm operation is available when powered on"
    end

    context("with :shutdown_guest") do
      let(:state) { :shutdown_guest }
      include_examples "Vm operation is not available"
    end

    context("with :standby_guest") do
      let(:state) { :standby_guest }
      include_examples "Vm operation is not available"
    end

    context("with :reset") do
      let(:state) { :reset }
      include_examples "Vm operation is not available"
    end
  end

  describe "#supports_terminate?" do
    context "when connected to a provider" do
      it "returns true" do
        expect(vm.supports_terminate?).to be_truthy
      end
    end

    context "when not connected to a provider" do
      let(:archived_vm) { FactoryBot.create(:vm_ibm_cloud_powervs) }

      it "returns false" do
        expect(archived_vm.supports_terminate?).to be_falsey
        expect(archived_vm.unsupported_reason(:terminate)).to eq("The VM is not connected to an active Provider")
      end
    end
  end
end