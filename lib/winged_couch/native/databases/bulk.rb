module WingedCouch
  module Native
    module Databases

      # Module for bulk inserting/updating records
      #
      module Bulk
        def bulk(docs)
          post bulk_path, docs
        end

        def bulk_path
          path.join("_bulk")
        end
      end

    end
  end
end