module WingedCouch
  module Models
    module Validation
      def self.included(klass)
        klass.extend ClassMethods
      end

      def errors
        native_document.errors
      end

      module ClassMethods

        def validations
          @validations ||= []
        end

        def must_exist(attribute_name, options = {})
          message = options[:message] || "#{attribute_name} is required"
          text = %Q{
            function(newDoc) {
              if (newDoc.#{attribute_name} == null) {
                throw({forbidden: \"#{message}\"})
              }
            }
          }.strip

          validations << proc { Design::Validation.upload(database, attribute_name, text) }
        end

        def upload_validation!
          validations.each(&:call)
        end

      end

    end
  end
end