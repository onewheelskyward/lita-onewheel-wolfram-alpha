require 'rest_client'

module Lita
  module Handlers
    class WolframAlpha < Handler
      config :app_id
      config :api_uri

      route(/^!alpha\s*(.*)/i, :handle_wolfram_query)

      def handle_wolfram_query(response)
        query = response.matches[0][0]
        xml_doc = make_api_call query
        response.reply query
      end

      def make_api_call(query)
        uri = build_uri query
      end

      def build_uri(query)
        uri = config.api_uri.sub '[query]', query
        uri = uri.sub '[appip]', config.app_ip
      end
    end
    Lita.register_handler(WolframAlpha)
  end
end
