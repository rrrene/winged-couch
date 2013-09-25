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

      end
    end
  end
end