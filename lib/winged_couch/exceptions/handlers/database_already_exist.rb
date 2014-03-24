module WingedCouch
  module Exceptions
    module Handlers
      class DatabaseAlreadyExist < Base
        def respond?
          precondition_failed? and database_level?
        end

        def call
          ::WingedCouch::Exceptions::DatabaseAlreadyExist.raise(db_name)
        end
      end
    end
  end
end
