require 'couch_orm/core_ext/chain_accessor'

require "couch_orm/configuration"
require "couch_orm/exceptions"

# Main module
#
module CouchORM
  extend Configuration

  # @private
  JAVASCRIPTS_PATH = File.expand_path("../couch_orm/javascripts", __FILE__)
end

require 'rest-client'
require "couch_orm/version"
require "couch_orm/http"
require "couch_orm/database"
require "couch_orm/view"
require "couch_orm/model"
require 'couch_orm/views_loader'
require 'couch_orm/queries/query_builder'
