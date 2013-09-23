require 'winged_couch/native/databases/http_delegation'

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

      # @private
      RESERVED_DATABASES = ["_users"]

      class << self

        # Returns all databases
        #
        # @return [Array<WingedCouch::Database>]
        #
        def all
          HTTP.get("/_all_dbs").map do |db_name|
            self.new(db_name)
          end
        end

        # @private
        #
        def each(&block)
          all.each(&block)
        end

        # Creates database in CouchDB and returns it
        #
        # @param name [String] name of database
        #
        # @return [WingedCouch::Database]
        # @raise [WingedCouch::DatabaseAlreadyExist] if database already exist
        #
        def create(name)
          HTTP.put("/#{name}")
          self.new(name)
        rescue => e
          raise Exceptions::DatabaseAlreadyExist.new("Database \"#{name}\" already exist.")
        end

      end

      attr_accessor :name

      def initialize(name)
        @name = name
      end

      # @private
      #
      def ==(other)
        other.is_a?(self.class) && name == other.name
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
        self.class.create(self.name)
      end

      # @private
      def inspect
        "#<#{self.class.name} name='#{self.name}'>"
      end

      alias_method :to_s,   :inspect
      alias_method :to_str, :inspect

      # Returns WingedCouch design document defined in current database
      #
      def design_document
        Design::Document.from(self)
      end

      # Returns all design views defined in WingedCouch design document in current database
      #
      def design_views
        design_document.data[:views]
      rescue => e
        raise Exceptions::NoDesignDocument.new("Can't find design document in database \"#{self.name}\".")
      end

      def documents_count
        get("/")["doc_count"]
      end

    end

  end
end