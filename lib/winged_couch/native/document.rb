require 'active_support/core_ext/hash'
require 'active_support/ordered_hash'
require 'active_support/json'

require 'winged_couch/native/documents/inspection'
require 'winged_couch/native/documents/accessors'
require 'winged_couch/native/documents/comparison'

module WingedCouch
  module Native

    # Low-level class for working with documents
    #
    class Document

      include Documents::Inspection
      include Documents::Accessors
      include Documents::Comparison

      attr_accessor :database
      attr_accessor :data

      def initialize(database, data = {}, retrieve_revision = false)
        @database = database
        @data = data.with_indifferent_access
        if retrieve_revision
          self._rev ||= revision
          @data.delete(:_rev) unless self._rev
        end
      end

      # Returns true if document exist
      #
      # @return [true, false]
      #
      def exist?
        HTTP.head(path)
        true
      rescue RestClient::ResourceNotFound
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
        rescue RestClient::Forbidden => e
          errors << JSON.parse(e.response)["reason"]
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
        if exist?
          HTTP.delete(path, default_params)
          @data["_rev"] = nil
          true
        else
          Exceptions::DocumentMissing.raise(%Q{Can't delete document with id "#{_id}" because it doesn't exist})
        end
      end

      # Updates document with passed data
      #
      # @return [WingedCouch::Native::Document] updated document with latest data and revision
      #
      # @raise [WingedCouch::Exceptions::DocumentMissing] if document doesn't exist
      #
      def update(data = {})
        if exist?
          @data.merge!(data)
          save
        else
          Exceptions::DocumentMissing.raise(%Q{Can't update document with id "#{_id}" because it doesn't exist})
        end
      end

      # Finds document in the database by id
      #
      # @param database [WingedCouch::Database::Database]
      # @param document_id [String]
      #
      # @return [WingedCouch::Native::Document]
      #
      def self.find(database, document_id)
        begin
          data = HTTP.get(database.path.join(document_id))
          self.new(database, data)
        rescue RestClient::ResourceNotFound
          nil
        end
      end

      def errors
        @errors ||= []
      end

      private

      # Fetches raw data from database
      #
      # @return [Hash]
      #
      def get
        HTTP.get(path, default_params) rescue nil
      end

      def base_path
        database.path
      end

      def path
        base_path.join(_id, :document)
      end

      def default_params
        _rev ? { rev: _rev } : {}
      end

    end

  end
end