# encoding: utf-8

module Loginza
  module ViewHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::UrlHelper
    
    # Loginza button
    #
    # Simple example:
    #   <%= loginza_button_tag("Login via OpenID", clients_path) %>
    # 
    # With set of providers:
    #   <%= loginza_button_tag("Login via OpenID", clients_path, :providers => [ :google, :facebook, :twitter ]) %>
    #
    # With default provider:
    #   <%= loginza_button_tag("Login via OpenID", clients_path, :provider => :google) %>
    #
    # With a block:
    #   <%= loginza_button_tag(clients_path, :provider => :google) do %>
    #     <div class='loginza'>
    #       ...
    #     </div>
    #   <% end %>
    #
    # Supported providers:
    #   google, yandex, mailruapi, mailru, vkontakte, facebook, twitter, loginza, myopenid, webmoney, rambler, flickr, lastfm, verisign, aol, steam, openid. 
    #
    def loginza_button_tag(*args, &block)
      if block_given?
        callback_url = args.first
        options      = args.second || {}
        html_options = args.third
        
        concat(loginza_button_tag(capture(&block), callback_url,  options, html_options))
      else
        name         = args[0]
        callback_url = args[1]
        options      = args[2] || {}
        html_options = args[3]
                  
        params = { :token_url => ::Rack::Utils.escape(callback_url) }
        
        if options[:providers]
          params[:providers_set] = options.delete(:providers).map(&:to_s).join(',')
        else
          params[:provider] = options.delete(:provider)
        end
        
        query = ::Rack::Utils.build_query(params)
        url = "https://loginza.ru/api/widget?#{query}"
        
        html = Utils.new_safe_buffer
        html << javascript_include_tag("http://s1.loginza.ru/js/widget.js")
        html << link_to(name, url, options, html_options)
        html
      end
    end
  end
end
