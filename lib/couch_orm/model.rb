require 'couch_orm/models/attributes'
require 'couch_orm/models/persistence'
require 'couch_orm/models/api'
require 'couch_orm/models/views'
require 'couch_orm/models/queries'

module CouchORM

  # Main model class
  #
  class Model
    include ::CouchORM::Models::Attributes
    include ::CouchORM::Models::Persistence
    include ::CouchORM::Models::API
    include ::CouchORM::Models::Views
    extend  ::CouchORM::Models::Queries
  end

end