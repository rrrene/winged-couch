module CouchORM
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
        # @return [CouchORM::Database]
        #
        def database
          @database ||= CouchORM::Database.new(database_name)
        end

        # Returns ids of all records in database for current model
        #
        # @return [Array<String>]
        #
        def record_ids
          database.get("/_all_docs")["rows"].map { |row| row["id"] }
        end

        # Returns revisions of all records in database for current model
        #
        # @return [Array<String>]
        #
        def rev_ids
          database.get("/_all_docs")["rows"].map { |row| row["value"]["rev"] }
        end

        private

        def database_name
          @serialize ||= begin
            word = self.name.to_s.dup
            word.gsub!('::', '_')
            word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
            word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
            word.tr!("-", "_")
            word.downcase!
            word
          end
        end

      end

      # Saves object to database or updates it if it was stored before
      #
      # @return [true, false] result of string
      #
      # @see #errors
      #
      def save
        begin
          persisted? ? save_for_update : save_first_time
          true
        rescue => e
          errors << e.message
          false
        end
      end

      # Removes record from database
      #
      # @return [true, false] result of removing
      #
      # @see #errors
      #
      def delete
        begin
          self.class.database.delete("/#{self._id}?rev=#{self._rev}")
          self._id = self._rev = nil
          true
        rescue => e
          errors << e.message
          false
        end
      end

      attr_accessor :_rev, :_id

      # Returns true if object is persisted
      #
      def persisted?
        _id && _rev
      end

      # Returns array of errors
      #
      # Fills when you have an error using `save` or `delete` methods
      #
      # @return [Array<String>]
      #
      def errors
        @_errors ||= []
      end

      private

      def serialize_to_json
        attrs = attributes
        attrs.merge!("_rev" => _rev) if _rev
        attrs.to_json
      end

      def save_first_time
        response = self.class.database.post("/", serialize_to_json)
        return false unless response["ok"]
        self._rev = response["rev"]
        self._id  = response["id"]
      end

      def save_for_update
        response = self.class.database.put("/#{self._id}", serialize_to_json)
        return false unless response["ok"]
        self._rev = response["rev"]
      end

    end
  end
end