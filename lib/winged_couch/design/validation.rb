module WingedCouch
  module Design

    # Class for uploading validation functions to CouchDB
    #
    class Validation

      # Default Id of validation document
      DOC_ID = "_design/validation"

      class << self

        # Uploads vadlition function to CouchDB
        #
        # @param database [WingedCouch::Native::Database]
        # @param name [String] name of validated attribute
        # @param validation [String] text of validation function
        #
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