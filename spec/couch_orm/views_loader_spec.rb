require 'spec_helper'

describe CouchORM::ViewsLoader do

  let(:model) { ModelWithDesignDoc }
  let(:loader) { CouchORM::ViewsLoader }
  let(:views) { ["all", "strings", "four"] }

  before(:each) do
    loader.filepath = File.join(GEM_ROOT, "spec", "support", "views.js")
  end

  around(:each) do |example|
    begin
      model.database.create
      example.run
    ensure
      model.database.drop
    end
  end

  it "should load JS fucntions from specified file" do
    loader.fetch(model).keys.should eq views
  end

  context "sending it to CouchDB" do
    it "creates it" do
      loader.upload_views_for(model)
      model.views.should eq views
    end

    it "updates it" do
      2.times { loader.upload_views_for(model) }
      model.views.should eq views
    end
  end

end
