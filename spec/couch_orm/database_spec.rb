require 'spec_helper'

describe CouchORM::Database do

  before(:each) { CouchORM::Database.each { |db| db.drop rescue nil } }

  it ".all" do
    CouchORM::Database.all.map(&:name).should include "_users"
  end

  it ".create" do
    db = CouchORM::Database.create("my_db")
    CouchORM::Database.all.should include db
    db.name.should eq "my_db"
  end

  it "#drop" do
    db = CouchORM::Database.create("my_db")
    db.drop
    CouchORM::Database.all.should_not include db
  end

  it "#exist?" do
    CouchORM::Database.create("my_db")
    expect(CouchORM::Database.new("my_db").exist?).to be_true
    expect(CouchORM::Database.new("non_existing_db").exist?).to be_false
  end

  context "delegation to CouchORM::HTTP" do

    let(:db) { CouchORM::Database.new("db_name") }

    it "#get" do
      CouchORM::HTTP.should_receive(:get).with("/db_name/123")
      db.get("/123")
    end

    it "#post" do
      CouchORM::HTTP.should_receive(:post).with("/db_name/123", { some: "data" })
      db.post("/123", { some: "data" })
    end

    it "#put" do
      CouchORM::HTTP.should_receive(:put).with("/db_name/123", { some: "data" })
      db.put("/123", { some: "data" })
    end

    it "#delete" do
      CouchORM::HTTP.should_receive(:delete).with("/db_name/123")
      db.delete("/123")
    end

  end

end