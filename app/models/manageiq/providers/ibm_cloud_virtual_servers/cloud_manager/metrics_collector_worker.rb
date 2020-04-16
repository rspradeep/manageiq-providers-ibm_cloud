class ManageIQ::Providers::IbmCloudVirtualServers::CloudManager::MetricsCollectorWorker < ManageIQ::Providers::BaseManager::MetricsCollectorWorker
  require_nested :Runner

  self.default_queue_name = "ibm_cloud_virtual_servers"

  def friendly_name
    @friendly_name ||= "C&U Metrics Collector for ManageIQ::Providers::IbmCloudVirtualServers"
  end
end
