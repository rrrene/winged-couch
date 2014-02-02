module WingedCouch
  module Native
    module Databases

      # Module with methods for making operations on the database
      #
      module Operations

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