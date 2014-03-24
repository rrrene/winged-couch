require 'winged_couch/native/databases/sugar'
require 'winged_couch/native/databases/bulk'
require 'winged_couch/native/databases/operations'

module WingedCouch
  module Native

    # Low-level class for managing databases in CouchDB
    #
    class Database < Abstract::Database

      include Databases::Sugar
      include Databases::Bulk
      include Databases::Operations

      # @private
      #
      RESERVED_DATABASES = ["_users", "_replicator"]

      # Drops the database
      #
      # @return [true]
      #
      # @raise [WingedCouch::Exceptions::ReservedDatabase] if database is internal (like "_users")
      # @raise [WingedCouch::Exceptions::NoDatabase] if database doesn't exist
      #
      # @example
      #   db = WingedCouch::Native::Database.create("my_db")
      #   # => #<WingedCouch::Native::Database name='my_db'>
      #   db.drop
      #   # => true
      #
      def drop
        check_database_name(name)
        HTTP.delete path
        @design_document = nil
        true
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
      #
      def exist?
        HTTP.head path
        true
      rescue Exceptions::NoDatabase
        false
      end

      # Creates database
      #
      # @raise [WingedCouch::Exceptions::DatabaseAlreadyExist] if database alread exist
      #
      def create
        HTTP.put path
        self
      end

      # Returns HTTP path to database
      #
      # @return [WingedCouch::HttpPath]
      #
      def path
        HTTP.path.join(name, :database)
      end

      def design_document
        doc = Design::Document.new(self)
        doc.exist? ? doc.reload : doc.save
        doc
      end

      private

      # Deleting reserved database (like "_users") crashes CouchDB :)
      #
      def check_database_name(name)
        Exceptions::ReservedDatabase.raise(name) if RESERVED_DATABASES.include?(name)
      end

    end

  end
end