require 'winged_couch/native/databases/http_delegation'
require 'winged_couch/native/databases/inspection'
require 'winged_couch/native/databases/design'
require 'winged_couch/native/databases/sugar'

module WingedCouch

  module Native

    # Class for managing databases in CouchDB
    #
    # @example Usage:
    #   db = WingedCouch::Database.create("db_name")
    #   # => #<WingedCouch::Database name="db_name">
    #
    #   db2 = WingedCouch::Database.create("db_name")
    #   # => DatabaseAlreadyExist error
    #
    #   db.drop
    #   # => true
    #
    #   db2.create
    #   # => true
    #
    #   WingedCouch::Database.new("non_existing_database").exist?
    #   # => false
    #
    #   db.exist?
    #   # => true
    #
    #   db2.exist?
    #   # => true
    #
    # WingedCouch::Database has interface for delegating
    # requests to WingedCouch::HTTP with /db_name prefix
    #
    # @example Delegation:
    #   WingedCouch::Database.new("my_existing_db").get("/record_id")
    #   # making get request to "http://couch-db-url:port/my_existing_db/record_id"
    #   # => { "some" => "response" }
    #
    class Database

      include WingedCouch::Native::Databases::HTTPDelegation
      include WingedCouch::Native::Databases::Inspection
      include WingedCouch::Native::Databases::Design
      include WingedCouch::Native::Databases::Sugar

      # @private
      RESERVED_DATABASES = ["_users"]

      class << self

        # Returns all databases
        #
        # @return [Array<WingedCouch::Database>]
        #
        def all
          HTTP.get("/_all_dbs").map { |db_name| self.new(db_name) }
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
      def drop
        if RESERVED_DATABASES.include?(name)
          raise Exceptions::ReservedDatabase, "Database \"#{self.name}\" is internal, you can't remove it."
        end
        HTTP.delete("/#{name}")
        true
      rescue RestClient::Exception
        raise Exceptions::NoDatabase, "Can't drop database \"#{self.name}\" because it doesn't exist."
      end

      # Returns true if database exist in CouchDB
      #
      # @return [true, false]
      #
      def exist?
        HTTP.get("/#{name}")
        true
      rescue => e
        return false if e.respond_to?(:http_code) && e.http_code == 404
        raise e
      end

      # Creates database with name `name`
      #
      # Simply delagates it to class
      #
      def create
        HTTP.put("/#{name}")
        self
      rescue => e
        raise Exceptions::DatabaseAlreadyExist.new("Database \"#{name}\" already exist.")
      end

      

    end

  end
end