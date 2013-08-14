require 'spec_helper'

describe CouchORM::Database do

  before(:each) { CouchORM::Database.each { |db| db.drop rescue nil } }

  it ".all" do
    CouchORM::Database.all.map(&:name).should include "_users"
  end

  context ".create" do

    it "creates database" do
      db = CouchORM::Database.create("my_db")
      CouchORM::Database.all.should include db
      db.name.should eq "my_db"
    end

    it "raises exception if database already exist" do
      expect {
        CouchORM::Database.create("my_db")
        CouchORM::Database.create("my_db")
      }.to raise_error(CouchORM::DatabaseAlreadyExist)
    end
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

  it "#inspect" do
    expected_str = "#<CouchORM::Database name='db_name'>"
    CouchORM::Database.new("db_name").inspect.should eq expected_str
  end

  it "#design_document" do
    expect {
      CouchORM::Database.new("db_name").design_document
    }.to raise_error(CouchORM::NoDesignDocument)
  end

  it "#design_views" do
    expect {
      CouchORM::Database.new("db_name").design_views
    }.to raise_error(CouchORM::NoDesignDocument)
  end

end