module WingedCouch
  module Native
    module Databases

      # @private
      module Inspection

        def inspect
          "#<#{self.class.name} name='#{self.name}'>"
        end

        alias_method :to_s,   :inspect
        alias_method :to_str, :inspect

      end
    end
  end
end