require 'spec_helper'

module WingedCouch
  module Native
    describe Database, :flush_dbs do

      subject(:database) { Database.new("my_db") }

      context "#create" do
        context "when database doesn't exist" do
          it "creates database" do
            database.create
            Server.all_dbs.should include(database.name)
          end
        end

        context "when database exists" do
          before { database.create }

          it "raises exception" do
            expect { database.create }.to raise_error(Exceptions::DatabaseAlreadyExist)
          end
        end
      end

      context "#drop" do
        context "when database exists" do
          before { database.create }

          it "drops database" do
            database.drop
            Server.all_dbs.should_not include(database.name)
          end
        end

        context "when database doesn't exist" do
          it "raises exception" do
            expect { database.drop }.to raise_error(Exceptions::NoDatabase)
          end
        end
      end

      context "#exist?" do
        context "when database exists" do
          before { database.create }
          its(:exist?) { should be_true }
        end

        context "when database doesn't exist" do
          its(:exist?) { should be_false }
        end
      end

    end

  end
end
