module WingedCouch
  module Models
    module Bulk

      def bulk_records
        @bulk_records ||= []
      end

      def bulk?
        @bulk
      end

      def bulk(group_size = 300)
        @bulk = true
        yield

        bulk_records.in_groups_of(group_size, false) do |group|
          docs = group.map(&:native_document).map(&:data)
          database.bulk(docs)
        end
        @bulk = false
      end

    end
  end
end