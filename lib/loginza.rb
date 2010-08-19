# encoding: utf-8
require 'loginza/railtie'

module Loginza
  autoload :ViewHelper, 'loginza/view_helper'
  autoload :Api,        'loginza/api'
  autoload :Utils,      'loginza/utils'
  autoload :Version,    'loginza/version'
  
  def self.user_data(token, options = {})
    options = options.dup

    data = begin
      auth_info(token, options)
    rescue ServerError
      return nil if $!.to_s=~/Data not found/
      raise
    end

    block_given? ? yield(data) : data
  end
  
  def self.auth_info(token, options = {})
    Api.call('authinfo', options.merge(:token => token))
  end
    
  class ServerError < RuntimeError; end
  class ApiError < ServerError; end
  class ServiceUnavailableError < ServerError; end
end
