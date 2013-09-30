require 'winged_couch/core_ext/chain_accessor'

require "winged_couch/configuration"
require "winged_couch/exceptions"

# Main module
#
module WingedCouch
  extend Configuration

  # @private
  JAVASCRIPTS_PATH = File.expand_path("../winged_couch/javascripts", __FILE__)

  # @private
  class Engine < ::Rails::Engine
  end if defined? Rails

  autoload :HTTP,        'winged_couch/http'
  autoload :Model,       'winged_couch/model'
  autoload :ViewsLoader, 'winged_couch/views_loader'

  module Native
    autoload :Server,   'winged_couch/native/server'
    autoload :Database, 'winged_couch/native/database'
    autoload :Document, 'winged_couch/native/document'
  end

  module Design
    autoload :View,     'winged_couch/design/view'
    autoload :Document, 'winged_couch/design/document'
  end

  module Queries
    autoload :BaseBuilder,  'winged_couch/queries/base_builder'
    autoload :QueryBuilder, 'winged_couch/queries/query_builder'
  end
end

require 'rest-client'
require "winged_couch/version"

if defined? Rails
  require 'winged_couch/rails'

  ActiveSupport.on_load(:action_view) do
    ActionView::Base.send(:include, WingedCouch::Rails::ViewHelpers)
  end
end