require 'spec_helper'

describe WingedCouch::Models::Persistence do

  let(:new_record) do
    s = OneFieldModel.new
    s.field = "value"
    s
  end

  around(:each) do |e|
    OneFieldModel.database.create
    e.run
    OneFieldModel.database.drop
  end

  it ".database" do
    OneFieldModel.database.should be_instance_of WingedCouch::Native::Database
    OneFieldModel.database.exist?.should be_true
  end

  describe "#save" do

    it "should save object in db" do
      new_record.save.should eq true
    end

    it "should update record in db" do
      new_record.save
      old_rev_ids = OneFieldModel.rev_ids
      new_record.save
      OneFieldModel.rev_ids.should_not eq old_rev_ids
    end

    it "should fetch ids of all records" do
      new_record.save
      OneFieldModel.record_ids.count.should eq 1
    end

    it "should mark object as persisted" do
      new_record.save
      new_record.should be_persisted
    end

    context "when object was not saved" do

      before(:each) do
        new_record.save
        new_record._rev = "123"
      end

      it "should return false" do
        new_record.save.should be_false
      end

      context "#errors" do
        it "should return reason if object was not saved" do
          new_record.save
          new_record.errors.first.should start_with "400"
        end
      end
    end

  end

  describe "#delete" do

    before(:each) do
      new_record.save
    end

    it "removes record from db" do
      new_record.delete.should be_true
      OneFieldModel.record_ids.should eq []
    end

    it "returns false if object wasn't removed" do
      new_record._rev = "123"
      new_record.delete.should be_false
      new_record.errors.first.should start_with "400"
    end

  end

end

