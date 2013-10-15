require 'spec_helper'

describe WingedCouch::Models::Persistence, :with_database do

  # class OneFieldModel < WingedCouch::Model
  #   attribute :field, String
  # end


  subject(:record) { OneFieldModel.new(field: "value") }
  let(:database) { OneFieldModel.database }

  it ".database" do
    database.should be_a(WingedCouch::Native::Database)
    database.exist?.should be_true
  end

  describe "#save" do

    before { record.save }

    it "should save object in db" do
      database.get(database.path.join(record._id)).should be_a(Hash)
    end

    it "should update record in db" do
      expect { record.save }.to change { record._rev }
    end

    it "should mark object as persisted" do
      record.should be_persisted
    end

    context "when object was not saved" do
      # break the object
      before(:each) { record.native_document.data[:_rev] = "123" }

      it "raises an error" do
        expect { record.save }.to raise_error
      end
    end

  end

  describe "#delete" do
    context "when object exist" do
      before { record.save; record.delete }

      it "removes record from db" do
        expect { database.get(database.path.join(record._id)) }.to raise_error
      end
    end

    context "when object doesn't exist" do
      before { record.native_document.data.merge!(_id: "id") }

      it "raises error" do
        expect { record.delete }.to raise_error
      end
    end

  end

  describe "#update" do
    before { record.save }

    context "when record exist" do
      before { record.update(field: "value2") }

      it "updates record" do
        record.field.should eq("value2")
      end

      it "updates document" do
        database.get(database.path.join(record._id))["field"].should eq("value2")
      end
    end

    context "when record doesn't exist" do
      # break the object
      before(:each) { record.native_document.data[:_rev] = "123" }

      it "raises an error" do
        expect { record.update(field: "value2") }.to raise_error
      end
    end
  end

end

