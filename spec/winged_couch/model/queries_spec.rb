require 'spec_helper'

describe WingedCouch::Models::Queries do

  before(:all) do
    ModelWithDesignDoc.database.create
    upload_views(ModelWithDesignDoc)
    ModelWithDesignDoc.create(type: "string", name: "Ilya")
    3.times { ModelWithDesignDoc.create(type: "string", name: "Vasya") }
    ModelWithDesignDoc.create(type: "fixnum")
  end

  after(:all) do
    ModelWithDesignDoc.database.drop
  end

  describe "querying map-only views" do
    subject(:result) { ModelWithDesignDoc.build(view: "strings").perform.records }

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
    subject(:result) { ModelWithDesignDoc.build(view: "four").perform.result }

    it "returns 4" do
      result.should eq(4)
    end
  end

  describe "utilities" do
    let(:query) { ModelWithDesignDoc.build(view: "by_name") }
    let(:reduce_query) { ModelWithDesignDoc.build(view: "key_objects") }

    describe ".descending" do
      let(:asc) { query.dup.descending(true).perform.records }
      let(:desc) { query.dup.descending(false).perform.records }

      it "returns records in specified order" do
        asc.reverse.should eq desc
      end
    end

    describe ".endkey" do
      let(:records) { query.endkey("Ilya").perform.records }

      it "stops querying when key = endkey" do
        records.count.should eq(1)
      end
    end

    describe ".endkey_docid" do
      let(:first_record) { query.perform.records.first }
      let(:records) { query.dup.endkey(first_record.name).endkey_docid(first_record._id).perform.records }

      it "stop querying on object with id = passed id" do
        records.should eq([first_record])
      end
    end

    describe ".include_docs" do
      let(:query_data) { query.include_docs(true).perform.data }

      it "includes docs in result" do
        query_data["rows"].first["doc"].should be_a(Hash)
      end
    end

    describe ".inclusive_end" do
      let(:inclusive_end) { query.endkey("Vasya").inclusive_end(true).perform.records }
      let(:not_inclusive_end) { query.endkey("Vasya").inclusive_end(false).perform.records }

      it "returns all record with/except endkey" do
        expect { all.count > first.count }.to be_true
      end
    end

    describe ".key" do
      it "filters by key" do
        query.key("Ilya").perform.records.count.should eq(1)
      end
    end

    it ".limit" do
      query.limit(2).perform.records.count.should eq(2)
    end

    describe ".reduce" do
      it "uses reduce function when reduce(true) called" do
        rows = reduce_query.reduce(true).perform.data["rows"]
        rows.length.should eq(1)
        rows.first["value"].should eq(reduce_query.reduce(true).perform.records)
      end

      it "doesn't use reduce function when reduce(false) called, uses only map function" do
        rows = reduce_query.reduce(false).perform.data["rows"]
        rows.length.should_not eq(1)
      end
    end

    it ".skip" do
      query.perform.records.count.should eq(query.dup.skip(1).perform.records.count + 1)
    end

    it ".stale" do
      query.stale(:ok).perform.records.should be_a(Array)
    end

    it ".startkey" do
      query.startkey("Vasya").perform.records.count.should eq(3)
    end

    it ".startkey_docid" do
      last_record = query.dup.perform.records.last
      query.startkey(last_record.name).startkey_docid(last_record._id).perform.records.should eq([last_record])
    end

    it ".update_seq" do
      query.update_seq(true).perform.update_seq.should_not be_nil
    end

  end
end
