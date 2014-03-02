module WingedCouch
  module Design

    # Class for working with design documents.
    #
    class Document < Native::Document

      # Default id of design document
      #
      DEFAULT_DOCUMENT_ID = "_design/winged_couch"

      # @param database [WingedCouch::Native::Database]
      # @param data [Hash] hash of attributes
      # @param retreive_revision [true, false] retrieves revision from the database if true passed
      #
      def initialize(database, data = {})
        super(database, data.merge(_id: DEFAULT_DOCUMENT_ID))
      end

      # Returns design document from passed database
      #
      # @param database [WingedCouch::Native::Database]
      #
      # @return WingedCouch::Design::Document
      #
      def self.from(database)
        new(database).reload
      end

      def path
        database.path.join(_id, :design_document)
      end

      # Returns all views specified in design document
      #
      # @return Array<WingedCouch::Design::Views>
      #
      def views
        data.fetch(:views, {}).map do |view_name, _|
          Design::View.from(self, view_name)
        end
      end

      def exist?
        super
      rescue Exceptions::NoDesignDocument
        false
      end

    end
  end
end