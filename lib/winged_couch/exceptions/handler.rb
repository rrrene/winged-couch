require "winged_couch/exceptions/handlers/base"
require "winged_couch/exceptions/handlers/no_database"
require "winged_couch/exceptions/handlers/database_already_exist"
require "winged_couch/exceptions/handlers/document_missing"
require "winged_couch/exceptions/handlers/invalid_document"
require "winged_couch/exceptions/handlers/no_design_document"

module WingedCouch
  module Exceptions
    class Handler

      HANDLERS = [
        Handlers::NoDatabase,
        Handlers::DatabaseAlreadyExist,
        Handlers::DocumentMissing,
        Handlers::InvalidDocument,
        Handlers::NoDesignDocument
      ]

      attr_reader :request_type, :http_path, :args, :exception

      def initialize(request_type, http_path, args, exception)
        @request_type = request_type
        @http_path = http_path
        @args = args
        @exception = exception
      end

      def run
        HANDLERS.each do |handler_klass|
          handler = handler_klass.new(request_type, http_path, args, exception)
          handler.call if handler.respond?
        end
        raise exception # When nothing found...
      end
      
    end
  end
end