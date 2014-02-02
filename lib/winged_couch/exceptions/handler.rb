require "winged_couch/exceptions/handlers/base"
require "winged_couch/exceptions/handlers/no_database"
require "winged_couch/exceptions/handlers/database_already_exist"
require "winged_couch/exceptions/handlers/document_missing"

module WingedCouch
  module Exceptions
    class Handler

      HANDLERS = [
        Handlers::NoDatabase,
        Handlers::DatabaseAlreadyExist,
        Handlers::DocumentMissing
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
          handler.raise if handler.respond?
        end
        raise exception # When nothing found...
      end
      
    end
  end
end