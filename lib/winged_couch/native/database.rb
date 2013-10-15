require 'winged_couch/native/databases/inspection'
require 'winged_couch/native/databases/design'
require 'winged_couch/native/databases/sugar'
require 'winged_couch/native/databases/bulk'

module WingedCouch

  module Native

    # Class for managing databases in CouchDB
    #
    # @example Usage:
    #   db = WingedCouch::Database.new("db_name")
    #   # => #<WingedCouch::Database name="db_name">
    #
    #   db.exist?
    #   # => false
    #
    #   db.create
    #   db.exist?
    #   # => true
    #
    #   db.create
    #   # => DatabaseAlreadyExist error
    #
    #   db.drop
    #   # => true
    #
    #   db.exist?
    #   # => false
    #
    class Database

      include Databases::Inspection
      include Databases::Design
      include Databases::Sugar
      include Databases::Bulk

      # @private
      RESERVED_DATABASES = ["_users"]

      class << self

        # Returns all databases
        #
        # @return [Array<WingedCouch::Database>]
        #
        # @example
        #   WingedCouch::Native::Database.all
        #   # => [#<WingedCouch::Native::Database name='_users'>]
        #
        def all
          Server.all_dbs.map { |db_name| self.new(db_name) }
        end

      end

      attr_accessor :name

      def initialize(name)
        @name = name
      end

      # Drops the database
      #
      # @raise [ReservedDatabase] if database name is reserved
      #
      # @return [String] response from CouchDB
      # @raise [WingedCouch::ReservedDatabase] if database is internal
      #
      # @raise [WingedCouch::NoDatabase] if database doesn't exist
      #
      # @example When database exist:
      #   db = WingedCouch::Native::Database.create("my_db")
      #   # => #<WingedCouch::Native::Database name='my_db'>
      #   db.drop
      #   # => true
      #
      # @example When database doesn't exist:
      #   db = WingedCouch::Native::Database.new("my_db")
      #   # => #<WingedCouch::Native::Database name='my_db'>
      #   db.drop
      #   # => WingedCouch::Exceptions::NoDatabase: Can't drop database "my_db" because it doesn't exist.
      #
      def drop
        check_database_name(name)
        HTTP.delete path
        true
      rescue RestClient::Exception
        raise Exceptions::NoDatabase, "Can't drop database \"#{self.name}\" because it doesn't exist."
      end

      # Returns true if database exist in CouchDB
      #
      # @return [true, false]
      #
      # @example
      #   db = WingedCouch::Native::Database.new("my_db")
      #   # => #<WingedCouch::Native::Database name='my_db'>
      #   db.exist?
      #   # => false
      def exist?
        HTTP.head path
        true
      rescue RestClient::ResourceNotFound
        false
      end

      # Creates database with name `name`
      #
      # Simply delagates it to class
      #
      def create
        HTTP.put path
        self
      rescue => e
        raise Exceptions::DatabaseAlreadyExist.new("Database \"#{name}\" already exist.")
      end

      # @private
      def path
        HTTP.path.join(name)
      end

      # @private
      def ==(other)
        other.is_a?(self.class) && name == other.name
      end

      private

      def check_database_name(name)
        if RESERVED_DATABASES.include?(name)
          raise Exceptions::ReservedDatabase, "Database \"#{self.name}\" is internal, you can't remove it."
        end
      end

    end

  end
end