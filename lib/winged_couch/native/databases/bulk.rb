require 'active_support/core_ext/array/grouping.rb'

module WingedCouch
  module Native
    module Databases

      # Module for bulk inserting/updating records
      #
      module Bulk
        def bulk(docs)
          HTTP.post bulk_path, { docs: docs }
        end

        def bulk_path
          path.join("_bulk_docs")
        end
      end

    end
  end
end