class SimpleModel < CouchORM::Model
  attribute :name, String
  attribute :gender, Symbol, default: "male"
  attribute :number, Fixnum
  attribute :unsupported, Object
end