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

  autoload :HttpPath,    'winged_couch/http_path'
  autoload :HTTP,        'winged_couch/http'
  autoload :Model,       'winged_couch/model'
  autoload :ViewsLoader, 'winged_couch/views_loader'

  module Abstract
    autoload :Database, 'winged_couch/abstract/database'
    autoload :Document, 'winged_couch/abstract/document'
  end

  module Native
    autoload :Server,   'winged_couch/native/server'
    autoload :Database, 'winged_couch/native/database'
    autoload :Document, 'winged_couch/native/document'
  end

  module Design
    autoload :View,       'winged_couch/design/view'
    autoload :Document,   'winged_couch/design/document'
    autoload :Validation, 'winged_couch/design/validation'
  end

  module Queries
    autoload :BaseBuilder,  'winged_couch/queries/base_builder'
    autoload :ViewBuilder,  'winged_couch/queries/view_builder'
    autoload :ViewResultProcessor, 'winged_couch/queries/view_result_processor'
  end

  module Tools
    autoload :Base,            'winged_couch/tools/base'
    autoload :ViewsUploader,   'winged_couch/tools/views_uploader'
    autoload :DatabaseCreator, 'winged_couch/tools/database_creator'
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