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
          Lita.logger.error 'lita-onewheel-wolfram-alpha: Configuration error!'
          return
        end
        query = response.matches[0][0]
        api_response = make_api_call query
        reply = parse_response api_response, query
        Lita.logger.debug "lita-onewheel-wolfram-alpha: Replying with #{reply}"
        response.reply reply
      end

      def parse_response(noko_doc, query)
        success_node = noko_doc.xpath('queryresult').attribute('success')
        Lita.logger.debug "lita-onewheel-wolfram-alpha: Success attr: #{success_node.to_s}"
        if success_node.to_s == 'true'
          pods = noko_doc.xpath('//pod')
          Lita.logger.debug "lita-onewheel-wolfram-alpha: Pod title: #{pods[1].attribute('title').to_s}"
          if pods[1].attribute('title').to_s == 'Plot'
            pods[1].xpath('//img')[1].attribute('src').to_s
          else
            rid_thee_of_extras pods[1].xpath('//plaintext')[1].child.to_s
          end

        else
          "lita-onewheel-wolfram-alpha: Wolfram couldn't parse #{query}."
        end
      end

      def rid_thee_of_extras(str)
        str.gsub /\s+\|\s/, ' | '
      end

      def make_api_call(query)
        Lita.logger.debug "lita-onewheel-wolfram-alpha: Making api call for #{query}"
        uri = build_uri query
        response = RestClient.get(uri)
        Nokogiri::XML response.to_s
      end

      def build_uri(query)
        uri = config.api_uri.sub '[query]', CGI::escape(query)
        uri.sub '[appid]', config.app_id
      end
    end
    Lita.register_handler(OnewheelWolframAlpha)
  end
end
