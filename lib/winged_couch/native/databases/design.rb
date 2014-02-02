module WingedCouch
  module Native
    module Databases

      # Module for using design features.
      #
      module Design

        # Returns WingedCouch design document defined in current database
        #
        def design_document
          @design_document ||= ::WingedCouch::Design::Document.from(self)
        end

        # Returns all design views defined in WingedCouch design document in current database
        #
        def design_views
          design_document.data[:views]
        rescue => e
          Exceptions::NoDesignDocument.raise(name)
        end

      end
    end
  end
end