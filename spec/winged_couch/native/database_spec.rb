require 'spec_helper'

describe WingedCouch::Native::Database do

  before(:each) { WingedCouch::Native::Database.each { |db| db.drop rescue nil } }

  it ".all" do
    WingedCouch::Native::Database.all.map(&:name).should include "_users"
  end

  context ".create" do

    it "creates database" do
      db = WingedCouch::Native::Database.create("my_db")
      WingedCouch::Native::Database.all.should include db
      db.name.should eq "my_db"
    end

    it "raises exception if database already exist" do
      expect {
        WingedCouch::Native::Database.create("my_db")
        WingedCouch::Native::Database.create("my_db")
      }.to raise_error(WingedCouch::Exceptions::DatabaseAlreadyExist)
    end
  end

  it "#drop" do
    db = WingedCouch::Native::Database.create("my_db")
    db.drop
    WingedCouch::Native::Database.all.should_not include db
  end

  it "#exist?" do
    WingedCouch::Native::Database.create("my_db")
    expect(WingedCouch::Native::Database.new("my_db").exist?).to be_true
    expect(WingedCouch::Native::Database.new("non_existing_db").exist?).to be_false
  end

  context "delegation to WingedCouch::HTTP" do

    let(:db) { WingedCouch::Native::Database.new("db_name") }

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
    expected_str = "#<WingedCouch::Native::Database name='db_name'>"
    WingedCouch::Native::Database.new("db_name").inspect.should eq expected_str
  end

  it "#design_document" do
    expect {
      WingedCouch::Native::Database.new("db_name").design_document
    }.to raise_error(WingedCouch::Exceptions::NoDesignDocument)
  end

  it "#design_views" do
    expect {
      WingedCouch::Native::Database.new("db_name").design_views
    }.to raise_error(WingedCouch::Exceptions::NoDesignDocument)
  end

end