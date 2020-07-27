require "ibm_cloud/api/iam/token"

module IbmCloud
  module API
    class IAM
      def self.endpoint
        "https://iam.cloud.ibm.com".freeze
      end

      def self.get_token(api_key)
        url = "#{endpoint}/identity/token"
        payload = {
          :grant_type => "urn:ibm:params:oauth:grant-type:apikey",
          :apikey     => api_key
        }
        headers = {
          "Content-Type" => "application/x-www-form-urlencoded",
          "Accept"       => "application/json"
        }

        response = RestClient.post(url, payload, headers)
        token_type, access_token = JSON.parse(response.body).values_at("token_type", "access_token")

        Token.new(token_type, access_token)
      end
    end
  end
end
