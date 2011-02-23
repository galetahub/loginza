# encoding: utf-8
require 'json'

module Loginza
  module Utils
    def self.turn_into_json(data)
      JSON.generate(data)
    end
    
    def self.parse_json(data)
      JSON.parse(data)
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
      params[:token_url] = callback_url
      params[:lang] ||= ::I18n.locale.to_s
      
      providers = options[:providers] ? options.delete(:providers).map(&:to_s).join(',') : options.delete(:provider)
      
      query = ::Rack::Utils.build_query(params)
      query += "&providers_set=#{providers}"

      "https://loginza.ru/api/widget?#{query}"
    end
  end
end
