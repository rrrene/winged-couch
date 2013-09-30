require 'spec_helper'

describe WingedCouch::Models::Queries do

  let(:database) { ModelWithDesignDoc.database }
  around(:each) do |example|
    begin
      database.create
      upload_views(ModelWithDesignDoc)
      ModelWithDesignDoc.create(type: "string", name: "Ilya")
      3.times { ModelWithDesignDoc.create(type: "string", name: "Vasya") }
      ModelWithDesignDoc.create(type: "fixnum")
      example.run
    ensure
      database.drop
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
    let(:reduce_query) { ModelWithDesignDoc.build(view: "key_objects") }

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

    it ".include_docs" do
      result = query.include_docs(true).perform(raw: true)
      result["rows"].first["doc"].should be_a(Hash)
    end

    it ".inclusive_end" do
      all   = query.endkey("Vasya").inclusive_end(true).perform
      first = query.endkey("Vasya").inclusive_end(false).perform
      expect { all.count > first.count }.to be_true
    end

    it ".key" do
      query.key("Ilya").perform.count.should eq(1)
    end

    it ".limit" do
      query.limit(2).perform.count.should eq(2)
    end

    describe ".reduce" do
      it "uses reduce function when reduce(true) called" do
        rows = reduce_query.reduce(true).perform(raw: true)["rows"]
        rows.length.should eq(1)
        rows.first["value"].should eq(reduce_query.reduce(true).perform)
      end

      it "doesn't use reduce function when reduce(false) called, uses only map function" do
        rows = reduce_query.reduce(false).perform(raw: true)["rows"]
        rows.length.should_not eq(1)
      end
    end

    it ".skip" do
      query.perform.count.should eq(query.skip(1).perform.count + 1)
    end

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

    it ".update_seq" do
      query.update_seq(true).perform(raw: true).should have_key("update_seq")
    end

  end
end
