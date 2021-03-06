class SimpleModel < WingedCouch::Model
  attribute :name, String
  attribute :gender, Symbol, default: "male"
  attribute :number, Fixnum
  attribute :unsupported, Class
end

class BlankModel < WingedCouch::Model
end

class OneFieldModel < WingedCouch::Model
  attribute :field, String
end

class ModelWithDesignDoc < WingedCouch::Model
  attribute :type, String
  attribute :name, String

  has_views :strings
end
