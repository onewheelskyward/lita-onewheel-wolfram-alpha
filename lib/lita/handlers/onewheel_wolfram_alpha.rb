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

        post_script = ''

        if matches = query.match(/\<(.*)\>/)
          Lita.logger.debug "Megamatch: #{matches[1]}"
          query.gsub! /\<.*\>/, ''
          post_script = " #{matches[1]}"
        end

        # fraction hack
        if query.match /\// and !query.match /\./
          query += ".0"
        end

        api_response = make_api_call query
        reply = parse_response api_response, query
        reply += post_script
        Lita.logger.debug "lita-onewheel-wolfram-alpha: Replying with #{reply}"
        response.reply reply
      end

      def parse_response(noko_doc, query)
        success_node = noko_doc.xpath('queryresult').attribute('success')
        Lita.logger.debug "lita-onewheel-wolfram-alpha: Success attr: #{success_node.to_s}"

        # No sense parsing if we didn't have success.
        if success_node.to_s == 'true'

          pods = noko_doc.xpath('//pod')
          Lita.logger.debug "lita-onewheel-wolfram-alpha: Pod title: #{pods[1].attribute('title').to_s}"

          title = pods[1].attribute('title').to_s
          if title == 'Plots' or title == 'Plot'  # Plot is a graph, grab the image.
            pods[1].xpath('//img')[1].attribute('src').to_s
          else  # Plaintext seems to work well for, say, Definition.
            rid_thee_of_extras pods[1].xpath('//plaintext')[1].child.to_s
          end

        else
          ["Nope, no #{query} to see here.",
           "#{query}?",
           'What\'s that, now?'
           ].sample
        end
      end

      def rid_thee_of_extras(str)
        str.gsub /\s+\|\s/, ' | '
      end

      def make_api_call(query)
        Lita.logger.debug "lita-onewheel-wolfram-alpha: Making api call for #{query}"
        uri = build_uri query
        Lita.logger.debug "lita-onewheel-wolfram-alpha: #{uri}"
        response = RestClient.get(uri)
        #Lita.logger.debug 'lita-onewheel-wolfram-alpha: ' + response.to_s
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
