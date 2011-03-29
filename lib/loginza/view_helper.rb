# encoding: utf-8
module Loginza
  module ViewHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    
    # Loginza button
    #
    # Simple example:
    #   <%= loginza_button_tag("Login via OpenID", clients_url) %>
    # 
    # With set of providers:
    #   <%= loginza_button_tag("Login via OpenID", clients_url, :providers => [ :google, :facebook, :twitter ]) %>
    #
    # With default provider:
    #   <%= loginza_button_tag("Login via OpenID", clients_url, :provider => :google) %>
    #
    # With a block:
    #   <%= loginza_button_tag(clients_url, :provider => :google) do %>
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
        
        loginza_button_tag(capture(&block), callback_url,  options, html_options)
      else
        name         = args[0]
        callback_url = args[1]
        options      = args[2] || {}
        html_options = args[3] || {}
                  
        html_options[:class] ||= "loginza"
        without_js = options.delete(:without_js) 

        url = Utils.generate_url(callback_url, options)
        
        html = Utils.new_safe_buffer
        html << javascript_include_tag("http://s1.loginza.ru/js/widget.js") unless without_js
        html << link_to(name, url, options, html_options)
        html
      end
    end
    
    # Loginza frame
    #
    # Simple example:
    #
    #   <%= loginza_frame_tag(clients_url, { :providers => [:google, :yandex, :mailru] }, { :style => "width:400px;height:350px;" }) %>
    #
    def loginza_frame_tag(callback_url, options = {}, html_options = {})
      html_options = { 
        :scrolling => "no",
        :frameborder => "no",
        :style => "width:359px;height:300px;",
      }.merge(html_options)
      
      html_options[:src] = Utils.generate_url(callback_url, options, { :overlay => 'loginza' })
      
      content_tag(:iframe, nil, html_options)
    end
  end
end
