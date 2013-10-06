require 'winged_couch/native/databases/http_delegation'
require 'winged_couch/native/databases/inspection'
require 'winged_couch/native/databases/design'
require 'winged_couch/native/databases/sugar'

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

      include Databases::HTTPDelegation
      include Databases::Inspection
      include Databases::Design
      include Databases::Sugar

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
          @all ||= HTTP.get("/_all_dbs").map { |db_name| self.new(db_name) }
        end

        # @private
        def reset_all
          @all = nil
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
        HTTP.delete("/#{name}")
        self.class.reset_all
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
        self.class.all.any? { |db| db.name == self.name }
      end

      # Creates database with name `name`
      #
      # Simply delagates it to class
      #
      def create
        HTTP.put("/#{name}")
        self.class.reset_all
        self
      rescue => e
        raise Exceptions::DatabaseAlreadyExist.new("Database \"#{name}\" already exist.")
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