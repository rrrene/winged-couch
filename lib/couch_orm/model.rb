require 'couch_orm/models/attributes'
require 'couch_orm/models/persistence'

module CouchORM

  # Main model class
  #
  class Model
    include ::CouchORM::Models::Attributes
    include ::CouchORM::Models::Persistence
  end

end