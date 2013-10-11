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
        @data[:_rev] ||= revision if retrieve_revision
      end

      # Returns true if document exist
      #
      # @return [true, false]
      #
      def exist?
        !!get rescue false
      end

      # Saves document in the database
      #
      # @return [true, false] result of saving document
      #
      def save
        begin
          @errors = []
          response = database.put(url, data_to_save)
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
          database.delete(url)
          @data["_rev"] = nil
          true
        else
          raise Exceptions::DocumentMissing, "Can't delete document with id \"#{_id}\" because it doesn't exist"
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
          raise Exceptions::DocumentMissing, "Can't update document because it doesn't exist"
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
          data = database.get("/#{document_id}")
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
        database.get(url) rescue nil
      end

      # Generated url for current document
      #
      # @return [String]
      def url(with_revision = _rev)
        if with_revision
          "/#{_id}?rev=#{_rev}"
        else
          "/#{_id}"
        end
      end

      # Returns data that need to be saved
      #
      # @return [String] json representation
      #
      def data_to_save
        @data.except(:_rev).to_json
      end

    end

  end
end