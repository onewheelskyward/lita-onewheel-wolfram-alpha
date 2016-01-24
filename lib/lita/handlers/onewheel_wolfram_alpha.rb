require 'rest_client'
require 'nokogiri'

module Lita
  module Handlers
    class OnewheelWolframAlpha < Handler
      config :app_id
      config :api_uri

      route(/^alpha\s*(.*)/i, :handle_wolfram_query, command: true)

      def handle_wolfram_query(response)
        unless config.app_id and config.api_uri
          Lita.logger.error 'Configuration error!'
          return
        end
        query = response.matches[0][0]
        api_response = make_api_call query
        response.reply api_response
      end

      def make_api_call(query)
        uri = build_uri query
        response = RestClient.get(uri)
        noko_doc = Nokogiri::XML response.to_s
        plaintext_nodes = noko_doc.xpath('//plaintext')
        plaintext_nodes[1].child.to_s
      end

      def build_uri(query)
        uri = config.api_uri.sub '[query]', CGI::escape(query)
        uri = uri.sub '[appid]', config.app_id
      end
    end
    Lita.register_handler(OnewheelWolframAlpha)
  end
end
