module WingedCouch
  module Abstract
    class Database

      attr_accessor :name

      def initialize(name)
        @name = name
      end

      # @private
      def ==(other)
        other.is_a?(self.class) && name == other.name
      end

      def inspect
        "#<#{self.class.name} name='#{self.name}'>"
      end

      alias_method :to_s,   :inspect
      alias_method :to_str, :inspect

    end
  end
end