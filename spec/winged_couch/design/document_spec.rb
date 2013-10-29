require 'spec_helper'

module WingedCouch
  module Design
    describe Document, :with_database do

      let(:database) { Native::Database.new("db_name") }
      subject(:document) { Document.new(database, key: "value") }

      describe "#initialize" do
        its(:database) { should eq(database) }
        its(:data) { should have_key(:key) }
      end

      describe ".from" do
        before { document.save }

        it "fetches design document from database" do
          Document.from(database).should eq(document)
        end
      end

    end
  end
end