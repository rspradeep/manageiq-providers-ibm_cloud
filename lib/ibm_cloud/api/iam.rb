require "ibm_cloud/api/base_service"

module IbmCloud
  module API
    class IAM < BaseService
      def endpoint
        "https://iam.cloud.ibm.com".freeze
      end

      def initialize(api_key)
        @api_key = api_key
      end

      def get_identity_token
        payload = {
          :grant_type => "urn:ibm:params:oauth:grant-type:apikey",
          :apikey     => api_key
        }

        result = post("identity/token", payload)

        require "ibm_cloud/api/iam/token"
        Token.new(*result.values_at("token_type", "access_token"))
      end

      private

      attr_reader :api_key

      def headers
        {
          "Content-Type" => "application/x-www-form-urlencoded",
          "Accept"       => "application/json"
        }
      end
    end
  end
end
