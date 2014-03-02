module WingedCouch
  module Exceptions
    module Handlers

      class InvalidDocument < Base

        def respond?
          forbidden? and document_level?
        end

        def raise
          ::WingedCouch::Exceptions::InvalidDocument.raise(response["reason"])
        end

      end

    end
  end
end
