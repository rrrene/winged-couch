module WingedCouch
  module Native
    module Databases

      # Module with utility methods
      #
      module Sugar
        
        include Enumerable

        def self.included(klass)
          klass.extend ClassMethods
        end

        # Class methods
        #
        module ClassMethods
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
            self.new(name).create
          end
        end

        # Returns information about the database
        #
        def info
          get("/")
        end

        # Returns count of documents in the database.
        #
        # @return [Fixnum]
        #
        def documents_count
          info["doc_count"]
        end

        # @private
        #
        def ==(other)
          other.is_a?(self.class) && name == other.name
        end

      end
    end
  end
end