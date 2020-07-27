require "ibm_cloud/api/resource_controller/resource"

module IbmCloud
  module API
    class ResourceController
      def self.endpoint
        "https://resource-controller.cloud.ibm.com/v2"
      end

      def initialize(token)
        @token = token
      end

      def get_resources
        url = "#{self.class.endpoint}/resource_instances"
        response = RestClient.get(url, headers)
        resources = JSON.parse(response.body)["resources"] || []
        resources.map { |instance| Resource.new(instance) }
      end

      def get_resource(guid)
        get_resources.detect { |resource| resource.guid == guid }
      end

      private

      attr_reader :token

      def headers
        {
          "Authorization" => token.authorization_header
        }
      end
    end
  end
end
