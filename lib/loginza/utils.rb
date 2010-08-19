# encoding: utf-8
require 'json' unless Object.const_defined?('ActiveSupport')

module Loginza
  module Utils
    def self.turn_into_json(data)
      if Object.const_defined?('ActiveSupport')
        ActiveSupport::JSON.encode(data)
      else
        JSON.generate(data)
      end
    end
    
    def self.parse_json(data)
      if Object.const_defined?('ActiveSupport')
        ActiveSupport::JSON.decode(data)
      else
        JSON.parse(data)
      end
    end
    
    def self.parse_query(value, spliter = '&')
      Rack::Utils.parse_query(value, spliter).inject({}) {|h,(k,v)|
        h[k] = Array === v ? v.first : v
        h
      }
    end
    
    def self.new_safe_buffer
      if Object.const_defined?('ActiveSupport')
        ActiveSupport::SafeBuffer.new
      else
        String.new
      end
    end
    
    def self.generate_url(callback_url, options = {}, params = {})
      params[:token_url] = ::Rack::Utils.escape(callback_url)
      
      if options[:providers]
        params[:providers_set] = options.delete(:providers).map(&:to_s).join(',')
      else
        params[:provider] = options.delete(:provider)
      end
      
      query = ::Rack::Utils.build_query(params)
      
      "https://loginza.ru/api/widget?#{query}"
    end
  end
end
