module WingedCouch
  module Models

    # Module for defining attribute validations
    #
    module Validation
      def self.included(klass)
        klass.extend ClassMethods
      end

      # Returns list of errors
      #
      def errors
        native_document.errors
      end

      module ClassMethods

        # Defines +presence+ validation
        #
        # @param attribute_name [Symbol]
        # @param options [Hash]
        # @option options [String] :message error message
        #
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

        def validations
          @validations ||= []
        end

        def upload_validation!
          validations.each(&:call)
        end

      end

    end
  end
end