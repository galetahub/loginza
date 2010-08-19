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
  end
end
