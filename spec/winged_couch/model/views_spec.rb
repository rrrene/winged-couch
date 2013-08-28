require 'spec_helper'

describe WingedCouch::Models::Views do

  context ".design" do

    it "stores design view" do
      ModelWithDesignDoc._views.tap do |docs|
        docs.count.should eq 1
        docs.first[:name].should eq :strings
      end
    end

    it "defines class method" do
      ModelWithDesignDoc.should respond_to :strings
    end

    context "defined method behaviour" do

      around(:each) do |example|
        begin
          ModelWithDesignDoc.database.create
          WingedCouch::ViewsLoader.filepath = File.join(GEM_ROOT, "spec", "support", "views.js")
          WingedCouch::ViewsLoader.upload_views_for(ModelWithDesignDoc)
          example.run
        ensure
          ModelWithDesignDoc.database.drop
        end
      end

      it "returns string records" do
        3.times { ModelWithDesignDoc.create(type: "string") }
        ModelWithDesignDoc.create(type: "non-string")
        docs = ModelWithDesignDoc.strings
        docs.count.should eq 3
        docs.each { |doc| doc.type.should eq "string" }
      end
    end

  end

end
