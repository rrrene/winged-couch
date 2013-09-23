module WingedCouch
  module Design
    class Document < Native::Document

      DOCUMENT_ID = "_design/winged_couch"

      def initialize(database, data = {})
        super(database, data.merge(_id: DOCUMENT_ID))
      end

      def self.from(database)
        new(database).reload
      rescue => e
        raise Exceptions::NoDesignDocument.new("Can't find design document in database \"#{self.name}\".")
      end

    end
  end
end