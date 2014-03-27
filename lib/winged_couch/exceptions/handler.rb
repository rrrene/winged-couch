require "winged_couch/exceptions/handlers/base"

module WingedCouch
  module Exceptions

    class Handler

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

      class DatabaseAlreadyExist < Handlers::Base
        respond? { precondition_failed? and database_level? }
        call { WingedCouch::Exceptions::DatabaseAlreadyExist.raise(db_name) }
      end

      class NoDatabase < Handlers::Base
        respond? { not_found? and database_level? }
        call { WingedCouch::Exceptions::NoDatabase.raise(db_name) }
      end

      class DocumentMissing < Handlers::Base
        respond? { not_found? and document_level? }
        call { WingedCouch::Exceptions::DocumentMissing.raise(http_path) }
      end

      class InvalidDocument < Handlers::Base
        respond? { forbidden? and document_level? }
        call { WingedCouch::Exceptions::InvalidDocument.raise(response["reason"]) }
      end

      class NoDesignDocument < Handlers::Base
        respond? { not_found? and design_document_level? }
        call { WingedCouch::Exceptions::NoDesignDocument.raise(db_name) }
      end

      HANDLERS = [
        NoDatabase,
        DatabaseAlreadyExist,
        DocumentMissing,
        InvalidDocument,
        NoDesignDocument
      ]

    end
  end
end