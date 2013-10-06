module WingedCouch

  # Module with design items: Document and View
  #
  module Design

    # Class for working with design documents.
    #
    class Document < Native::Document

      DOCUMENT_ID = "_design/winged_couch"

      # Constructor
      #
      # @param database [WingedCouch::Native::Database]
      # @param data [Hash] hash of attributes
      # @param retreive_revision [true, false] retrieves revision from the database if true passed
      #
      def initialize(database, data = {}, retreive_revision = false)
        super(database, data.merge(_id: DOCUMENT_ID), retreive_revision)
      end

      # Returns design document from passed database
      #
      # @param database [WingedCouch::Native::Database]
      #
      # @return WingedCouch::Design::Document
      #
      def self.from(database)
        new(database).reload
      rescue => e
        raise Exceptions::NoDesignDocument.new("Can't find design document in database \"#{self.name}\".")
      end

    end
  end
end