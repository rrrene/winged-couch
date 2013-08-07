class SimpleModel < CouchORM::Model
  attribute :name, String
  attribute :gender, Symbol, default: "male"
  attribute :number, Fixnum
  attribute :unsupported, Object
end

class BlankModel < CouchORM::Model
end

class OneFieldModel < CouchORM::Model
  attribute :field, String
end

class ModelWithDesignDoc < CouchORM::Model
  attribute :type, String

  view :strings, client: true
end