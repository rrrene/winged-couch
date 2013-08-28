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
      # @raise [CouchORM::DatabaseAlreadyExist] if database already exist
      #
      def create(name)
        CouchORM::HTTP.put("/#{name}")
        self.new(name)
      rescue => e
        raise CouchORM::DatabaseAlreadyExist.new("Database \"#{name}\" already exist.")
      end

    end

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    # @private
    #
    def ==(other)
      other.is_a?(CouchORM::Database) && name == other.name
    end

    # Drops the database
    #
    # @raise [ReservedDatabase] if database name is reserved
    #
    # @return [String] response from CouchDB
    # @raise [CouchORM::ReservedDatabase] if database is internal
    #
    # @raise [CouchORM::NoDatabase] if database doesn't exist
    #
    def drop
      raise CouchORM::ReservedDatabase.new("Database \"#{self.name}\" is internal, you can't remove it.") if RESERVED_DATABASES.include?(name)
      CouchORM::HTTP.delete("/#{name}")
      true
    rescue => e
      raise CouchORM::NoDatabase.new("Can't drop database \"#{self.name}\" because it doesn't exist.")
    end

    # Returns true if database exist in CouchDB
    #
    # @return [true, false]
    #
    def exist?
      CouchORM::HTTP.get("/#{name}")
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

    # Returns CouchORM design document defined in current database
    #
    def design_document
      get("/_design/couch_orm")
    rescue => e
      raise CouchORM::NoDesignDocument.new("Can't find design document in database \"#{self.name}\".")
    end

    # Returns all design views defined in CouchORM design document in current database
    #
    def design_views
      design_document["views"]
    rescue => e
      raise CouchORM::NoDesignDocument.new("Can't find design document in database \"#{self.name}\".")
    end

  end
end