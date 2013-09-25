module WingedCouch
  module Native
    module Documents
      module Accessors

        def _id
          @data[:_id]
        end

        def _rev
          @data[:_rev]
        end

        def revision
          get["_rev"] rescue nil
        end

        def _id=(new_id)
          @data[:_id] = new_id
        end

        def _rev=(new_rev)
          @data[:_rev] = new_rev
        end

      end
    end
  end
end