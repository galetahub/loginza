# encoding: utf-8

module Loginza
  module ViewHelper
    include ActionView::Helpers::AssetTagHelper
    
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
    def loginza_button_tag(name, callback_url, options = {}, html_options = {}, &block)
      if block_given?
        callback_url = args.first
        options      = args.second || {}
        html_options = args.third
        
        concat(loginza_button_tag(capture(&block), callback_url,  options, html_options))
      else
        name         = args.first
        callback_url = args.second
        options      = args.third || {}
        html_options = args.four
        
        params = { :token_url => ::Rack::Utils.escape(callback_url) }
        
        if options[:providers]
          params[:providers_set] = options[:providers].map(&:to_s).join(',')
        else
          params[:provider] = options[:provider]
        end
        
        query = ::Rack::Utils.build_query(params)
        url = "https://loginza.ru/api/widget?#{query}"
        
        if html_options
          html_options = html_options.stringify_keys
          href = html_options['href']
          convert_options_to_javascript!(html_options, url)
          tag_options = tag_options(html_options)
        else
          tag_options = nil
        end

         href_attr = "href=\"#{url}\"" unless href
         
         html = Utils.new_safe_buffer
         html << javascript_include_tag("http://s1.loginza.ru/js/widget.js")
         html << "<a #{href_attr}#{tag_options}>#{name || url}</a>".html_safe
         
         html
      end
    end

  end
end
