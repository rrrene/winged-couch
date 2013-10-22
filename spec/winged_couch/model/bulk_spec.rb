require 'spec_helper'

module WingedCouch
  module Models
    describe Bulk, :with_database do

      class Model < ::WingedCouch::Model
        attribute :name, String
      end

      let(:database) { Model.database }

      context "bulk insert" do
        it "creates records" do
          Model.bulk do
            10.times do |i|
              Model.create(name: "Name #{i}")
            end
          end

          HTTP.get(database.path.join("_all_docs"))["total_rows"]
        end

        it "creates records in one request" do
          HTTP.should_receive(:post).once

          Model.bulk do
            10.times do |i|
              Model.create(name: "Name #{i}")
            end
          end
        end
      end

    end
  end
end