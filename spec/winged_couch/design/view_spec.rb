require 'spec_helper'

module WingedCouch
  module Design
    describe View, :with_database do

      let(:database) { Native::Database.new("my_db") }
      let(:design_document) { Document.new(database) }
      let(:text) { "function(doc) { emit(doc.id, doc); }" }
      subject(:view) { View.new(design_document, "all") }

      before { design_document.save }

      describe "#initialize" do
        its(:design_document) { should eq(design_document) }
        its(:view_name)       { should eq("all") }
      end

      describe ".create" do

        it "creates view in the specified design document" do
          View.create(design_document, "all", "map", text)
          design_document.reload
          design_document.data[:views][:all][:map].should eq(text)
        end

        it "keeping existing views" do
          View.create(design_document, "all", "map", text)
          View.create(design_document, "other", "map", text)
          design_document.reload
          design_document.data[:views].tap do |views_hash|
            views_hash.should have_key(:all)
            views_hash.should have_key(:other)
          end
        end
      end

      describe "#source" do
        it "returns source soce of view" do
          view = View.create(design_document, "all", "map", text)
          view.source["map"].should eq(text)
        end
      end

      describe ".from" do
        it "creates instance" do
          View.create(design_document, "all", "map", text)
          View.from(design_document, "all").should
        end
      end

    end
  end
end