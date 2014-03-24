require 'spec_helper'

module WingedCouch
  module Queries
    describe ViewBuilder, :with_model do

      model :TestModel do
        attribute :amount, Fixnum
        attribute :type, String
      end

      views({
        all_docs: {
          map: "function(doc) { emit(doc._id, doc) }"
        },
        map_reduce: {
          map: "function(doc) { emit(doc._id, doc); }",
          reduce: "function(key, values) { return 42; }"
        }
      })

      let(:view) { WingedCouch::Design::View.from(TestModel.design_document, "all_docs") }

      subject(:builder) { ViewBuilder.new(view, TestModel) }

      describe "#initialize" do
        its(:view) { should eq(view) }
      end

      let!(:records) do
        (1..5).map { |i| TestModel.create(amount: i, type: "any") }
      end

      describe "#all" do
        it "returns all records" do
          builder.all.should =~ records
        end
      end

      describe "#count" do
        it "returns count of records without creating model instances" do
          TestModel.should_not_receive(:new)
          builder.count.should eq(5)
        end
      end

      describe "params chaining" do
        it "allows to specify params through chaining" do
          builder.
            descending(true).
            endkey("John").
            endkey_docid("some-doc-id").
            # group(true).    # for reduce-views only
            # group_level(2). # for reduce-views only
            include_docs(true).
            inclusive_end(true).
            key("John").
            limit(10).
            # reduce(true).   # we have no reduce function for all_docs view :)
            skip(2).
            stale("ok").
            startkey("John").
            startkey_docid("some-doc-id").
            update_seq(true).
            all.should be_a(Array)
        end
      end

      describe "fetching data from map-reduce views" do
        let(:view) { WingedCouch::Design::View.from(TestModel.design_document, "map_reduce") }
        let(:builder) { ViewBuilder.new(view, TestModel) }

        it "correctly returns result" do
          builder.all.should eq(42)
        end
      end

    end
  end
end