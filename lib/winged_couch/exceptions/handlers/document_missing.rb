module WingedCouch
  module Exceptions
    module Handlers

      class DocumentMissing < Base

        def respond?
          not_found? and document_level?
        end

        def raise
          ::WingedCouch::Exceptions::DocumentMissing.raise(document_name)
        end

      end

    end
  end
end
