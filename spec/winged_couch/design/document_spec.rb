require 'spec_helper'

module WingedCouch
  module Design
    describe Document, :with_database do

      let(:database) { Native::Database.new("db_name") }
      subject(:document) { Document.new(database, key: "value") }

      describe "#initialize" do
        it "overrides passed document id" do
          document._id.should eq(Document::DEFAULT_DOCUMENT_ID)
        end
      end

      describe ".from" do
        context "when design document doesn't exist" do
          it "raises exception" do
            expect { Document.from(database) }.to raise_error(Exceptions::NoDesignDocument)
          end
        end

        context "when design document exists" do
          before { document.save }

          it "fetches design document from database" do
            Document.from(database).should eq(document)
          end
        end
      end

    end
  end
end