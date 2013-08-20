require 'spec_helper'

describe CouchORM::Models::Queries do
  around(:each) do |example|
    begin
      ModelWithDesignDoc.database.create
      CouchORM::ViewsLoader.filepath = File.join(GEM_ROOT, "spec", "support", "views.js")
      CouchORM::ViewsLoader.upload_views_for(ModelWithDesignDoc)
      example.run
    ensure
      ModelWithDesignDoc.database.drop
    end
  end

  describe "querying map-only views" do
    before do
      3.times { ModelWithDesignDoc.create(type: "string") }
      ModelWithDesignDoc.create(type: "fixnum")
    end

    subject(:result) { ModelWithDesignDoc.build(view: "strings").perform }

    it "should return 3 records by default" do
      result.count.should eq 3
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
    before do
      3.times { ModelWithDesignDoc.create(type: "string") }
      ModelWithDesignDoc.create(type: "fixnum")
    end

    subject(:result) { ModelWithDesignDoc.build(view: "four").perform }

    it "returns 4" do
      result.should eq(4)
    end
  end
end