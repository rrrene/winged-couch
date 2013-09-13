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

  autoload :HTTP,        'winged_couch/http'
  autoload :Database,    'winged_couch/database'
  autoload :View,        'winged_couch/view'
  autoload :Model,       'winged_couch/model'
  autoload :ViewsLoader, 'winged_couch/views_loader'
  autoload :Server,      'winged_couch/server'

  module Queries
    autoload :BaseBuilder,  'winged_couch/queries/base_builder'
    autoload :QueryBuilder, 'winged_couch/queries/query_builder'
  end
end

require 'rest-client'
require "winged_couch/version"
