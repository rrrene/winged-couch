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
          HTTP.get path
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

        # Returns changes for current database
        #
        # @param options [Hash]
        #
        # @see http://wiki.apache.org/couchdb/HTTP_database_API#Changes
        #
        # @return Hash
        #
        def changes(options = {})
          HTTP.get path.join("_changes"), options
        end

        # Compacts current database
        #
        # @erturn Hash { "ok" => true }
        #
        def compact
          HTTP.post path.join("_compact")
        end

        def compact_doc(doc_id)
          HTTP.post path.join("_compact/#{doc_id}")
        end

        def view_cleanup
          HTTP.post path.join("_view_cleanup")
        end

        def ensure_full_commit
          HTTP.post path.join("_ensure_full_commit")
        end

      end
    end
  end
end