require 'spec_helper'

module WingedCouch
  module Native
    describe Database do

      around(:each) do |example|
        Database.each { |db| db.drop rescue nil }
      end

      context ".all" do
        it "returns all databases" do
          Database.all.should eq [Database.new("_users")]
        end
      end

      context ".create" do

        context "when database doesn't exist" do
          it "creates database" do
            Database.create("my_db")
            Server.all_dbs.should include("my_db")
          end
        end

        context "when database alread exist" do
          before { Database.create("my_db") }

          it "raises exception if database already exist" do
            expect { Database.create("my_db") }.to raise_error(Exceptions::DatabaseAlreadyExist)
          end
        end

        it "returns instance of database" do
          db = Database.create("my_db")
          db.should be_a(Database)
          db.name.should eq("my_db")
        end
      end

      context "#drop" do
        let(:database) { Database.new("my_db") }

        context "when database exist" do
          before { database.create }

          it "drops database" do
            database.drop
            Database.all.should_not include database
          end

          it "returns true" do
            database.drop.should eq(true)
          end
        end

        context "when database doesn't exist" do
          it "raises exception" do
            expect { database.drop }.to raise_error(Exceptions::NoDatabase)
          end
        end

        context "when database name is reserved" do
          let(:database) { Database.new("_users") }

          it "raises exception" do
            expect { database.drop }.to raise_error(Exceptions::ReservedDatabase)
          end
        end
      end

      context "#exist?" do
        subject(:database) { Database.new("my_db") }

        context "when database exist" do
          before { database.create }

          its(:exist?) { should be_true }
        end

        context "when database doesn't exist" do
          its(:exist?) { should be_false }
        end
      end

      context "delegation to HTTP" do

        let(:database) { Database.new("db_name") }

        it "#get" do
          HTTP.should_receive(:get).with("/db_name/123")
          database.get("/123")
        end

        it "#post" do
          HTTP.should_receive(:post).with("/db_name/123", some: "data")
          database.post("/123", some: "data")
        end

        it "#put" do
          HTTP.should_receive(:put).with("/db_name/123", some: "data")
          database.put("/123", some: "data")
        end

        it "#delete" do
          HTTP.should_receive(:delete).with("/db_name/123")
          database.delete("/123")
        end

      end

      it "#inspect" do
        expected_str = "#<WingedCouch::Native::Database name='db_name'>"
        Database.new("db_name").inspect.should eq(expected_str)
      end

      context "#design" do
        let(:database) { Database.new("db_name") }
        let(:design_document) { Document.new(database, _id: "_design/winged_couch") }
        
        before { database.create }

        context "#design_document" do
          context "when design document exist" do
            it "raises exception" do
              expect { database.design_document }.to raise_error(Exceptions::NoDesignDocument)
            end
          end

          context "when design document exist" do
            before { design_document.save }

            it "should return design document" do
              database.design_document.should be_a(Design::Document)
            end
          end
        end

        context "#design_views" do
          context "when design document exist" do
            it "raises exception" do
              expect { database.design_views }.to raise_error(Exceptions::NoDesignDocument)
            end
          end

          context "when design document doesn't exist" do
            it "should return design view" # TODO: implement
          end
        end

      end

    end

  end
end
