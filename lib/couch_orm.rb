require 'rest-client'
require "couch_orm/version"
require "couch_orm/http"
require "couch_orm/configuration"
require "couch_orm/database"
require "couch_orm/view"
require "couch_orm/model"
require 'couch_orm/views_loader'

# Main module
#
module CouchORM
  extend Configuration
end
