module WingedCouch
  module Exceptions
    module Handlers
      class NoDesignDocument < Base
        def respond?
          not_found? and design_document_level?
        end

        def call
          ::WingedCouch::Exceptions::NoDesignDocument.raise(db_name)
        end
      end
    end
  end
end
