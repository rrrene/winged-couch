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
end

require 'rest-client'
require "winged_couch/version"
require "winged_couch/http"
require "winged_couch/database"
require "winged_couch/view"
require "winged_couch/model"
require 'winged_couch/views_loader'
require 'winged_couch/queries/query_builder'
