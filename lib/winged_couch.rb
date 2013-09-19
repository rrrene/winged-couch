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

    rake_tasks do
      load "tasks/winged_couch.rake"
    end
  end if defined? Rails

  module Native
    autoload :Server,      'winged_couch/native/server'
    autoload :Database,    'winged_couch/native/database'
    autoload :View,        'winged_couch/native/view'
    autoload :Document,    'winged_couch/native/document'
  end

  autoload :HTTP,        'winged_couch/http'
  autoload :Model,       'winged_couch/model'
  autoload :ViewsLoader, 'winged_couch/views_loader'

  module Queries
    autoload :BaseBuilder,  'winged_couch/queries/base_builder'
    autoload :QueryBuilder, 'winged_couch/queries/query_builder'
  end
end

require 'rest-client'
require "winged_couch/version"
