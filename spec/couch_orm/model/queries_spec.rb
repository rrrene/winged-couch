require 'spec_helper'

describe CouchORM::Models::Queries do
  around(:each) do |example|
    begin
      ModelWithDesignDoc.database.create
      upload_views(ModelWithDesignDoc)
      ModelWithDesignDoc.create(type: "string", name: "Ilya")
      3.times { ModelWithDesignDoc.create(type: "string", name: "Vasya") }
      ModelWithDesignDoc.create(type: "fixnum")
      example.run
    ensure
      ModelWithDesignDoc.database.drop
    end
  end

  describe "querying map-only views" do
    subject(:result) { ModelWithDesignDoc.build(view: "strings").perform }

    it "should return 3 records by default" do
      result.count.should eq 4
    end

    it "should return instances of this class" do
      result.each { |record| record.should be_a(ModelWithDesignDoc) }
    end

    it "should return records with type 'string'" do
      result.each { |record| record.type.should eq("string") }
    end

    it "should have _id and _rev fields" do
      result.each do |r|
        r._id.should_not be_nil
        r._rev.should_not be_nil
      end
    end
  end

  describe "querying map-reduce views" do
    subject(:result) { ModelWithDesignDoc.build(view: "four").perform }

    it "returns 4" do
      result.should eq(4)
    end
  end

  describe "utilities" do
    let(:query) { ModelWithDesignDoc.build(view: "by_name") }

    it ".descending" do
      asc  = query.descending(true).perform
      desc = query.descending(false).perform
      asc.reverse.should eq desc
    end

    it ".endkey" do
      query.endkey("Ilya").perform.count.should eq(1)
    end

    it ".endkey_docid" do
      first_record = query.perform.first
      query.endkey(first_record.name).endkey_docid(first_record._id).perform.should eq([first_record])
    end

    it ".group"
    it ".group_level"
    it ".include_docs"
    it ".inclusive_end"

    it ".key" do
      query.key("Ilya").perform.count.should eq(1)
    end

    it ".limit"
    it ".reduce"
    it ".skip"

    it ".stale" do
      query.stale(:ok).perform.should be_a(Array)
    end

    it ".startkey" do
      query.startkey("Vasya").perform.count.should eq(3)
    end

    it ".startkey_docid" do
      last_record = query.perform.last
      query.startkey(last_record.name).startkey_docid(last_record._id).perform.should eq([last_record])
    end

    it ".update_seq"

  end
end