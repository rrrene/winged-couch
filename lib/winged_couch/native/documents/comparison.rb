module WingedCouch
  module Native
    module Documents

      # @private
      module Comparison

        def ==(other)
          other.is_a?(self.class) &&
            other.database == self.database &&
            other._id      == self._id &&
            other._rev     == self._rev
        end

      end
    end
  end
end