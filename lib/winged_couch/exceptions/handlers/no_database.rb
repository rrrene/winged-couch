module WingedCouch
  module Exceptions
    module Handlers

      class NoDatabase < Base

        def respond?
          not_found? and database_level?
        end

        def raise
          ::WingedCouch::Exceptions::NoDatabase.raise(db_name)
        end

      end

    end
  end
end
