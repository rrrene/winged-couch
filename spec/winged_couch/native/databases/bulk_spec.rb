require 'spec_helper'

module WingedCouch
  module Native
    module Databases
      describe Bulk, :with_database do

        describe ".bulk" do
          let(:data) do
            [ { field: "value1" }, { field: "value2" } ]
          end

          let(:database) { Database.new(:db) }

          it "inserts multiple documents to the database" do
            database.bulk(data)
            database.documents_count.should eq(2)
          end
        end

      end
    end
  end
end
