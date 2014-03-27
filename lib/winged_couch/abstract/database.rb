module WingedCouch
  module Abstract

    # Class which represents abstract database.
    #   It implements base logic for database class.
    #
    # @example
    #   database1 = WingedCouch::Abstract::Database.new("database-name")
    #   # => #<WingedCouch::Abstract::Database name='database-name'>
    #
    #   database2 = WingedCouch::Abstract::Database.new("database-name")
    #   # => #<WingedCouch::Abstract::Database name='database-name'>
    #
    #   database3 = WingedCouch::Abstract::Database.new("database-name2")
    #   # => #<WingedCouch::Abstract::Database name='database-name2'>
    #
    #   database1 == database2
    #   # => true
    #
    #   database1 == database3
    #   # => false
    #
    class Database

      attr_reader :name

      def initialize(name)
        @name = name
      end

      # Compares database with passed object
      #   Returns true if passed object has same class and database name
      #
      # @param other [Object] object to compare
      #
      # @return [true, false]
      #
      def ==(other)
        other.instance_of?(self.class) && name.present? && name == other.name
      end

      # Returns the contents of the document as a nicely formatted string.
      #
      # @return [String]
      #
      def inspect
        "#<#{self.class} name='#{self.name}'>"
      end

    end
  end
end