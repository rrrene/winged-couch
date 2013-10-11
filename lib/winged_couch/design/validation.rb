module WingedCouch
  module Design
    class Validation

      DOC_ID = "_design/validation"

      class << self
        def upload(database, name, validation)
          data = {
            _id: [DOC_ID, name].join("_"),
            validate_doc_update: validation
          }
          doc = Native::Document.new(database, data)
          doc.save
        end
      end

    end
  end
end