require 'spec_helper'

module WingedCouch
  module Abstract
    describe Document do

      let(:database) { Database.new("test") }
      let(:document_id) { "document_id" }
      let(:revision) { "revision" }
      let(:data) { { "key" => "value", "_id" => document_id, "_rev" => revision } }

      subject(:document) { Document.new(database, data) }

      context "#initialize" do
        it "stores passed database" do
          document.database.should eq(database)
        end

        it "stores passed data" do
          document.data.should eq(data)
        end
      end

      describe "#inspect" do
        context "full document" do
          let(:expected) { %{#<WingedCouch::Abstract::Document database="test", _id="document_id", _rev="revision", key="value">} }
          its(:inspect) { should eq(expected) }
        end

        context "blank record" do
          let(:expected) { %{#<WingedCouch::Abstract::Document database="test", _id=nil, _rev=nil>} }
          before { document.data = Hash.new }
          its(:inspect) { should eq(expected) }
        end
      end

      describe "#_id" do
        let(:new_id) { "new_id" }

        it "returns document id" do
          document._id.should eq(document_id)
        end

        it "allows to set document id" do
          document._id = new_id
          document._id.should eq(new_id)
        end
      end

      describe "#_rev" do
        let(:new_revision) { "new_revision" }

        it "return document revision" do
          document._rev.should eq(revision)
        end

        it "allows to set revision" do
          document._rev = new_revision
          document._rev.should eq(new_revision)
        end
      end

      describe "#==" do
        let(:data) { { key: "value" } }

        let(:doc1) { Document.new(database, data) }
        let(:doc2) { Document.new(database, data) }

        it "compares documents" do
          doc1.should == doc2
        end
      end

    end
  end
end
