module WingedCouch
  module Native

    # Low-level class for working with documents
    #
    class Document < Abstract::Document

      def fetch_revision!
        self._rev = get["_rev"]
      end

      # Returns true if document exist
      #
      # @return [true, false]
      #
      def exist?
        HTTP.head path
        true
      rescue Exceptions::DocumentMissing
        false
      end

      # Saves document in the database
      #
      # @return [true, false] result of saving document
      #
      def save
        begin
          @errors = []
          response = HTTP.put(path, data)
          @data[:_rev] = response["rev"]
          true
        rescue Exceptions::InvalidDocument => e
          errors << e.message
          false
        end
      end

      # Reloads document with latest data from database
      #
      # @return [WingedCouch::Native::Document] reloaded document with latest data
      #
      def reload
        @data = get.with_indifferent_access
        self
      end

      # Removed document from the database
      #
      # @return true
      #
      # @raise [WingedCouch::Exceptions::DocumentMissing] if document doesn't exits
      #
      def delete
        HTTP.delete(path, default_params)
        @data["_rev"] = nil
      end

      # Updates document with passed data
      #
      # @return [WingedCouch::Native::Document] updated document with latest data and revision
      #
      def update(data = {})
        @data.merge!(data)
        save
      end

      # Finds document in the database by id
      #
      # @param database [WingedCouch::Database::Database]
      # @param document_id [String]
      #
      # @return [WingedCouch::Native::Document]
      #
      def self.find(database, document_id)
        data = { _id: document_id }
        self.new(database, data).reload
      end

      def errors
        @errors ||= []
      end

      def path
        database.path.join(_id, :document)
      end

      private

      # Fetches raw data from database
      #
      # @return [Hash]
      #
      def get
        HTTP.get(path, default_params)
      end

      def default_params
        _rev ? { rev: _rev } : {}
      end

    end

  end
end