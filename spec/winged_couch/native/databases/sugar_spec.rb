require 'spec_helper'

module WingedCouch
  module Native
    module Databases
      describe Sugar, :flush_dbs do

        context ".all" do
          it "returns all databases" do
            Database.all.map(&:name).should eq(Server.all_dbs)
          end
        end

        context ".create" do
          let!(:database) { Database.create("db_name") }

          it "create database and returns instance" do
            Database.all.should include(database)
          end
        end

      end
    end
  end
end
