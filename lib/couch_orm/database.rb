module CouchORM

  # Class for managing databases in CouchDB
  #
  # @example Usage:
  #   db = CouchORM::Database.create("db_name")
  #   # => #<CouchORM::Database name="db_name">
  #
  #   db2 = CouchORM::Database.create("db_name")
  #   # => DatabaseAlreadyExist error
  #
  #   db.drop
  #   # => true
  #
  #   db2.create
  #   # => true
  #
  #   CouchORM::Database.new("non_existing_database").exist?
  #   # => false
  #
  #   db.exist?
  #   # => true
  #
  #   db2.exist?
  #   # => true
  #
  # CouchORM::Database has interface for delegating
  # requests to CouchORM::HTTP with /db_name prefix
  #
  # @example Delegation:
  #   CouchORM::Database.new("my_existing_db").get("/record_id")
  #   # making get request to "http://couch-db-url:port/my_existing_db/record_id"
  #   # => { "some" => "response" }
  #
  class Database

    # @private
    RESERVED_DATABASES = ["_users"]

    # @private
    class ReservedDatabase < StandardError; end
    # @private
    class DatabaseAlreadyExist < StandardError; end

    class << self

      # Returns all databases
      #
      # @return [Array<CouchORM::Database>]
      #
      def all
        CouchORM::HTTP.get("/_all_dbs").map do |db_name|
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
      # @return [CouchORM::Database]
      #
      def create(name)
        self.new(name).tap do |db|
          raise DatabaseAlreadyExist if db.exist?
          CouchORM::HTTP.put("/#{name}")
        end
      end

    end

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    # @private
    #
    def ==(other)
      name == other.name
    end

    # Drops the database
    #
    # @raise [ReservedDatabase] if database name is reserved
    #
    # @return [String] response from CouchDB
    #
    def drop
      raise ReservedDatabase if RESERVED_DATABASES.include?(name)
      !!CouchORM::HTTP.delete("/#{name}") rescue false
    end

    # Returns true if database exist in CouchDB
    #
    # @return [true, false]
    #
    def exist?
      !!CouchORM::HTTP.get("/#{name}") rescue false
    end

    # Creates database with name `name`
    #
    # Simply delagates it to class
    #
    def create
      CouchORM::Database.create(self.name)
    end

    # Performs get request to database
    # (simply delegates to CouchORM::HTTP with `database name` prefix)
    #
    def get(url)
      CouchORM::HTTP.get("/#{name}#{url}")
    end

    # Performs post request to database
    # (simply delegates to CouchORM::HTTP with `database name` prefix)
    #
    def post(url, data)
      CouchORM::HTTP.post("/#{name}#{url}", data)
    end

    # Performs put request to database
    # (simply delegates to CouchORM::HTTP with `database name` prefix)
    #
    def put(url, data)
      CouchORM::HTTP.put("/#{name}#{url}", data)
    end

    # Performs delete request to database
    # (simply delegates to CouchORM::HTTP with `database name` prefix)
    #
    def delete(url)
      CouchORM::HTTP.delete("/#{name}#{url}")
    end

    # @private
    def inspect
      "#<CouchORM::Database name='#{self.name}'>"
    end

    alias_method :to_s,   :inspect
    alias_method :to_str, :inspect

  end
end