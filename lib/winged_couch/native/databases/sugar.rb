module WingedCouch
  module Native
    module Databases

      # Module with utility methods
      #
      module Sugar

        def self.included(klass)
          klass.extend ClassMethods
        end

        # Class methods
        #
        module ClassMethods

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

          include Enumerable

          # Iterates over all CouchDB database
          #
          # @yield [WingedCouch::Native::Database]
          #
          def each(&block)
            all.each(&block)
          end

          # Creates database in CouchDB and returns it
          #
          # @param name [String] name of database
          #
          # @return [WingedCouch::Database]
          #
          # @raise [WingedCouch::Exceptions::DatabaseAlreadyExist] if database already exist
          #
          def create(name)
            self.new(name).create
          end
        end

      end
    end
  end
end