require 'active_support/core_ext/hash'
require 'active_support/ordered_hash'

require 'winged_couch/native/documents/inspection'
require 'winged_couch/native/documents/accessors'
require 'winged_couch/native/documents/comparison'

module WingedCouch
  module Native

    class Document

      include Documents::Inspection
      include Documents::Accessors
      include Documents::Comparison

      attr_accessor :database
      attr_accessor :data

      def initialize(database, data = {})
        @database = database
        @data = data.with_indifferent_access
        @data[:_rev] ||= revision
      end

      def exist?
        !!get rescue false
      end

      def get
        database.get(url) rescue nil
      end

      def save
        response = database.put(url, data_to_save)
        @data[:_rev] = response["rev"]
        self
      end

      def reload
        @data = get.with_indifferent_access
        self
      end

      def delete
        if exist?
          database.delete(url)
          @data["_rev"] = nil
          true
        else
          raise Exceptions::DocumentMissing, "Can't delete document with id \"#{_id}\" because it doesn't exist"
        end
      end

      def update(data = {})
        if exist?
          @data.merge!(data)
          save
        else
          raise Exceptions::DocumentMissing, "Can't update document because it doesn't exist"
        end
      end

      def self.find(database, document_id)
        begin
          data = database.get("/#{document_id}")
          self.new(database, data)
        rescue RestClient::ResourceNotFound
          nil
        end
      end

      private

      def url(with_revision = _rev)
        if with_revision
          "/#{_id}?rev=#{_rev}"
        else
          "/#{_id}"
        end
      end

      def data_to_save
        @data.except(:_rev).to_json
      end

    end

  end
end