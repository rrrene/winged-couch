require 'spec_helper'

describe CouchORM::View do

  let(:model) { ModelWithDesignDoc }
  let(:view_loader) { CouchORM::ViewsLoader }
  let(:database) { model.database }

  let(:view) { CouchORM::View.new(database, "strings") }
  let(:non_existing_view) { CouchORM::View.new(database, "non_existing_view") }

  around(:each) do |example|
    database.create
    view_loader.filepath = File.join(GEM_ROOT, "spec", "support", "views.js")
    view_loader.upload_views_for(ModelWithDesignDoc)
    example.run
    database.drop
  end


  context "#exist?" do
    it "returns true if view exist" do
      expect(view.exist?).to be_true
    end

    it "returns false if view doesn't exist" do
      expect(non_existing_view.exist?).to be_false
    end
  end

  it "#get" do
    model.create(type: "string")
    response = view.get
    response["rows"].count.should eq 1
  end

  it "#source" do
    view.source.should have_key "map"
  end

  context ".all" do
    it "returns views if database exist" do
      expected_data = [CouchORM::View.new(database, "all"), CouchORM::View.new(database, "strings"), CouchORM::View.new(database, "four")]
      CouchORM::View.all(database).should eq expected_data
    end

    it "returns blank array if database doesn't exist" do
      non_existing_database = CouchORM::Database.new("non_existing_database")
      CouchORM::View.all(non_existing_database).should eq []
    end
  end

  it ".names" do
    CouchORM::View.names(database).should eq ["all", "strings", "four"]
  end

  it "#inspect" do
    CouchORM::View.new(database, "test_view").inspect.should eq "#<CouchORM::View name='test_view', database='model_with_design_doc'>"
  end

end