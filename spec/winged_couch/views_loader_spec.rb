require 'spec_helper'

module WingedCouch
  describe ViewsLoader, :with_database do

    let(:model) { ModelWithDesignDoc }
    let(:database) { ModelWithDesignDoc.database }
    let(:loader) { ViewsLoader }
    let(:views) { ["all", "strings", "by_name", "four", "key_objects"] }

    before(:each) do
      loader.filepath = File.join(GEM_ROOT, "spec", "support", "views.js")
    end

    describe ".fetch" do
      it "loads JS fucntions from specified file" do
        ViewsLoader.fetch(ModelWithDesignDoc).keys.should eq views
      end
    end

    describe ".upload_views_for" do
      it "it creates views" do
        ViewsLoader.upload_views_for(ModelWithDesignDoc)
        ModelWithDesignDoc.views.should eq views
      end

      context "updating" do
        before { ViewsLoader.upload_views_for(ModelWithDesignDoc) }

        it "updates it" do          
          ViewsLoader.upload_views_for(ModelWithDesignDoc)
          ModelWithDesignDoc.views.should eq views
        end
      end
    end

  end
end