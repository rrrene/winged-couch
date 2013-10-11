require 'active_support/core_ext/module/delegation'
require 'active_support/inflector'
require 'securerandom'

module WingedCouch
  module Models

    # Main module for storing records in CouchDB
    #
    module Persistence

      # @private
      #
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      # Module with class methods for persistence
      #
      module ClassMethods

        # Returns database for current model
        #
        # @return [WingedCouch::Database]
        #
        def database
          @database ||= WingedCouch::Native::Database.new(database_name)
        end

        private

        def database_name
          self.name.demodulize.underscore
        end

      end

      delegate :_id, :_rev, :_id=, :_rev=, :delete, :update, to: :native_document

      # Saves object to database or updates it if it was stored before
      #
      # @return [true, false] result of string
      #
      # @see #errors
      #
      def save
        native_document._id ||= SecureRandom.hex
        native_document.save
      end

      # Returns true if object is persisted
      #
      def persisted?
        _id && _rev
      end

    end
  end
end