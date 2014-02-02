require 'spec_helper'

module WingedCouch
  module Abstract
    describe Database do

      context "#initialize" do
        let(:db_name) { double(:db_name) }

        it "stores database name" do
          Database.new(db_name).name.should eq(db_name)
        end
      end

      context "#==" do
        let(:database) { Database.new(:name) }
        let(:same_database) { Database.new(:name) }
        let(:another_object) { double(:another_object) }

        it "compares 'self' with passed object" do
          database.should == same_database
          database.should_not == another_object
        end
      end

      context "#inspect" do
        let(:database) { Database.new("people") }
        let(:expected_result) { "#<WingedCouch::Abstract::Database name='people'>" }

        it "converts database to string" do
          database.inspect.should eq(expected_result)
        end
      end

    end
  end
end
