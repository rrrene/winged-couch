require 'spec_helper'

module WingedCouch
  module Design
    describe Document do

      let(:database) { Native::Database.new("db_name") }
      subject(:document) { Document.new(database, key: "value") }

      around(:each) do |example|
        begin
          database.create
          example.run
        ensure
          database.drop
        end
      end

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