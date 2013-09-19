require 'active_support/core_ext/hash'
require 'active_support/ordered_hash'

module WingedCouch
  module Native

    class Document

      attr_accessor :database
      attr_accessor :data

      def initialize(database, data = {})
        @database = database
        @data = data.with_indifferent_access
        @data[:_rev] ||= revision
      end

      def _id
        @data[:_id]
      end

      def _rev
        @data[:_rev]
      end

      def exist?
        !!get rescue false
      end

      def get
        database.get(url) rescue nil
      end

      def revision
        get["_rev"] rescue nil
      end

      def save
        response = database.put(url, save_data)
        @data[:_rev] = response["rev"]
        self
      end

      def reload
        @data = get.with_indifferent_access
        self
      end

      def inspect
        inspected_data = ActiveSupport::OrderedHash.new
        inspected_data[:database] = database.name
        inspected_data[:_id] = @data[:_id]
        inspected_data[:_rev] = @data[:_rev]
        @data.except(:_rev, :_id).each { |k, v| inspected_data[k] = v }
        "#<WingedCouch::Native::Document #{inspected_data.map { |k,v| "#{k}=#{v.inspect}" }.join(", ")}>"
      end

      alias_method :to_s,   :inspect
      alias_method :to_str, :inspect

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
          raise Exceptions::DocumentMissing, "Can't update document because it doesn't exist" unless exist?
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

      def save_data
        @data.except(:_rev).to_json
      end

    end

  end
end