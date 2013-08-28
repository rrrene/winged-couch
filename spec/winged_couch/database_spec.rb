require 'spec_helper'

describe WingedCouch::Database do

  before(:each) { WingedCouch::Database.each { |db| db.drop rescue nil } }

  it ".all" do
    WingedCouch::Database.all.map(&:name).should include "_users"
  end

  context ".create" do

    it "creates database" do
      db = WingedCouch::Database.create("my_db")
      WingedCouch::Database.all.should include db
      db.name.should eq "my_db"
    end

    it "raises exception if database already exist" do
      expect {
        WingedCouch::Database.create("my_db")
        WingedCouch::Database.create("my_db")
      }.to raise_error(WingedCouch::DatabaseAlreadyExist)
    end
  end

  it "#drop" do
    db = WingedCouch::Database.create("my_db")
    db.drop
    WingedCouch::Database.all.should_not include db
  end

  it "#exist?" do
    WingedCouch::Database.create("my_db")
    expect(WingedCouch::Database.new("my_db").exist?).to be_true
    expect(WingedCouch::Database.new("non_existing_db").exist?).to be_false
  end

  context "delegation to WingedCouch::HTTP" do

    let(:db) { WingedCouch::Database.new("db_name") }

    it "#get" do
      WingedCouch::HTTP.should_receive(:get).with("/db_name/123")
      db.get("/123")
    end

    it "#post" do
      WingedCouch::HTTP.should_receive(:post).with("/db_name/123", { some: "data" })
      db.post("/123", { some: "data" })
    end

    it "#put" do
      WingedCouch::HTTP.should_receive(:put).with("/db_name/123", { some: "data" })
      db.put("/123", { some: "data" })
    end

    it "#delete" do
      WingedCouch::HTTP.should_receive(:delete).with("/db_name/123")
      db.delete("/123")
    end

  end

  it "#inspect" do
    expected_str = "#<WingedCouch::Database name='db_name'>"
    WingedCouch::Database.new("db_name").inspect.should eq expected_str
  end

  it "#design_document" do
    expect {
      WingedCouch::Database.new("db_name").design_document
    }.to raise_error(WingedCouch::NoDesignDocument)
  end

  it "#design_views" do
    expect {
      WingedCouch::Database.new("db_name").design_views
    }.to raise_error(WingedCouch::NoDesignDocument)
  end

end