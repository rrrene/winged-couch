require 'active_support/core_ext/hash'
require 'active_support/ordered_hash'
require 'active_support/json'

module WingedCouch
  module Abstract
    class Document

      attr_accessor :database
      attr_accessor :data

      def initialize(database, data = {})
        @database = database
        @data = data.with_indifferent_access
      end

      def inspect
        inspected_data = ActiveSupport::OrderedHash.new.tap do |h|
          h[:database] = database.name
          h[:_id]  = data[:_id]
          h[:_rev] = data[:_rev]
          data.except(:_rev, :_id).each { |k, v| h[k] = v }
        end.map { |k,v| "#{k}=#{v.inspect}" }.join(", ")
        "#<#{self.class.name} #{inspected_data}>"
      end

      alias_method :to_s,   :inspect
      alias_method :to_str, :inspect

      def _id
        data[:_id]
      end

      def _rev
        data[:_rev]
      end

      def _id=(new_id)
        data[:_id] = new_id
      end

      def _rev=(new_rev)
        data[:_rev] = new_rev
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.database == self.database &&
          other._id      == self._id &&
          other._rev     == self._rev
      end

    end
  end
end
