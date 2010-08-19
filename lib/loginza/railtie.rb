# encoding: utf-8
require 'loginza'

module Loginza
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'loginza.insert_into_action_view' do
        Loginza::Railtie.insert
      end
    end
  end

  class Railtie
    def self.insert
      ActionView::Base.send(:include, Loginza::ViewHelper)
    end
  end
end


