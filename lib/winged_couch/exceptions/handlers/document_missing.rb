module WingedCouch
  module Exceptions
    module Handlers
      class DocumentMissing < Base
        def respond?
          not_found? and document_level?
        end

        def call
          ::WingedCouch::Exceptions::DocumentMissing.raise(http_path)
        end
      end
    end
  end
end
