require 'spec_helper'

module WingedCouch
  describe ViewsLoader, :with_model do

    model :TestModel do
      attribute :name, String
    end

    views(all: { map: "" }, favourite: { map: "" })

    let(:database) { ::TestModel.database }

    let(:design_document) { TestModel.design_document }

    describe ".fetch" do
      it "loads JS fucntions from specified file" do
        ViewsLoader.fetch(TestModel).keys.should eq ["all", "favourite"]
      end
    end

    describe ".upload_views_for" do
      it "it creates views" do
        ViewsLoader.upload_views_for(TestModel)
        TestModel.views.map(&:view_name).should eq ["all", "favourite"]
      end

      context "updating" do
        it "updates it" do          
          2.times { ViewsLoader.upload_views_for(TestModel) }
          TestModel.views.map(&:view_name).should eq ["all", "favourite"]
        end
      end
    end

  end
end