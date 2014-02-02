require 'spec_helper'

module WingedCouch
  module Native
    module Databases
      describe Design, :with_database do

        let(:database) { Database.new("db_name") }
        let(:design_document) { Document.new(database, _id: "_design/winged_couch") }
        
        context "#design_document" do
          context "when design document exist" do
            it "raises exception" do
              expect { database.design_document }.to raise_error(Exceptions::NoDesignDocument)
            end
          end

          context "when design document exist" do
            before { design_document.save }

            it "returns design document" do
              database.design_document.should be_a(WingedCouch::Design::Document)
            end
          end
        end

        context "#design_views" do
          context "when design document doesn't exist" do
            it "raises exception" do
              expect { database.design_views }.to raise_error(Exceptions::NoDesignDocument)
            end
          end

          context "when design document exist" do
            before do
              design_document.save
              WingedCouch::Design::View.create(design_document, "all", "map", "function(doc) { emit(doc); }")
            end

            it "returns design views" do
              database.design_views.should have_key("all")
            end
          end
        end


      end
    end
  end
end