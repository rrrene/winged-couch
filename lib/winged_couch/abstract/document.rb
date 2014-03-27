require 'active_support/core_ext/hash'
require 'active_support/ordered_hash'
require 'active_support/json'

module WingedCouch
  module Abstract

    # Class which represents abstract document.
    #   It implements base logic for document class.
    #
    class Document

      attr_accessor :database
      attr_accessor :data

      def initialize(database, data = {})
        @database = database
        @data = data.with_indifferent_access
      end

      # Returns the contents of the document as a nicely formatted string.
      #
      # @return [String]
      #
      def inspect
        "#<#{self.class.name} data=#{data.inspect}>"
      end

      # Returns document id
      #
      # @return [String]
      #
      def _id
        data[:_id]
      end

      # Returns document revision
      #
      # @return [String]
      #
      def _rev
        data[:_rev]
      end

      # Sets document id
      #
      # @param new_id [String] new document id
      #
      def _id=(new_id)
        data[:_id] = new_id
      end

      # Sets document revision
      #
      # @param new_rev [String] new document revision
      #
      def _rev=(new_rev)
        data[:_rev] = new_rev
      end

      # Returns true if +other_object+ is an object of same class,
      #   stored in the same database and has same +_id+ and +_rev+
      #
      # @param other_object [Object] obejct to compare
      #
      def ==(other_object)
        other_object.instance_of?(self.class) &&
          database.present? && other_object.database == self.database &&
          _id.present?      && other_object._id      == self._id      &&
          _rev.present?     && other_object._rev     == self._rev
      end

    end
  end
end

