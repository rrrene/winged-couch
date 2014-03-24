require 'spec_helper'

module WingedCouch
  module Models
    describe Bulk, :with_model do

      model :BulkModel do
        attribute :name, String
      end

      context "bulk insert" do
        it "creates records" do
          BulkModel.bulk do
            10.times do |i|
              BulkModel.create(name: "Name #{i}")
            end
          end

          HTTP.get(database.path.join("_all_docs"))["total_rows"]
        end

        it "creates records in one request" do
          HTTP.should_receive(:post).once

          BulkModel.bulk do
            10.times do |i|
              BulkModel.create(name: "Name #{i}")
            end
          end
        end
      end

    end
  end
end