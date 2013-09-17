require 'spec_helper'

describe WingedCouch::Native::View do

  let(:model) { ModelWithDesignDoc }
  let(:view_loader) { WingedCouch::ViewsLoader }
  let(:database) { model.database }
  let(:view_names) { ["all", "strings", "by_name", "four", "key_objects"] }

  let(:view) { WingedCouch::Native::View.new(database, "strings") }
  let(:non_existing_view) { WingedCouch::Native::View.new(database, "non_existing_view") }

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
      expected_data = view_names.map { |view| WingedCouch::Native::View.new(database, view) }
      WingedCouch::Native::View.all(database).should eq expected_data
    end

    it "returns blank array if database doesn't exist" do
      non_existing_database = WingedCouch::Native::Database.new("non_existing_database")
      WingedCouch::Native::View.all(non_existing_database).should eq []
    end
  end

  it ".names" do
    WingedCouch::Native::View.names(database).should eq view_names
  end

  it "#inspect" do
    WingedCouch::Native::View.new(database, "test_view").inspect.should eq "#<WingedCouch::View name='test_view', database='model_with_design_doc'>"
  end

end