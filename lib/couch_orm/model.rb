require 'couch_orm/models/attributes'
require 'couch_orm/models/persistence'
require 'couch_orm/models/api'

module CouchORM

  # Main model class
  #
  class Model
    include ::CouchORM::Models::Attributes
    include ::CouchORM::Models::Persistence
    include ::CouchORM::Models::API
  end

end