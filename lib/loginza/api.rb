# encoding: utf-8
require 'net/http'
require 'net/https'

module Loginza  
  module Api
    class << self
      
      BASE_URL = "http://loginza.ru/api/"
      
      def call(method, data, cookies = {})
        options = {
          :timestamp => Time.now.to_i
        }.merge(data)
                
        response = request(File.join(uri.path, method), options)
        parse_response(response)
      end
      
      def uri
        @@uri ||= URI.parse(BASE_URL)
        @@uri
      end
      
      protected

        def request(path, data)
          client.request(request_object(path, data))
        end

        def request_object(path, data)
          request = Net::HTTP::Post.new("#{path}?token=#{data.delete(:token)}")
          request.form_data = stringify_keys(data)
          request
        end
        
        # symbol keys -> string keys
        # because of ruby 1.9.x bug in Net::HTTP
        # http://redmine.ruby-lang.org/issues/show/1351
        def stringify_keys(hash)
          hash.map{|k,v| [k.to_s,v]}
        end

        def client
          client = Net::HTTP.new(uri.host, uri.port)
          client
        end

        def parse_response(response)
          if response.code.to_i >= 400
            raise ServiceUnavailableError, "The Loginza service is temporarily unavailable. (4XX)"
          else
            begin
              result = Utils.parse_json(response.body)
            rescue Exception => e
              ::Rails.logger.info("Error parse: #{response.body}")
              ::Rails.logger.error(e)
              return
            end
            
            return result unless result['error_type']
            
            raise ApiError, "Got error: #{result['error_message']} (error_type: #{result['error_type']}), HTTP status: #{response.code}"
          end
        end
    end
  end
end
