require 'spec_helper'

module WingedCouch
  module Models
    describe Validation do

      class ModelWithValidation < WingedCouch::Model
        attribute :name, String
        must_exist :name, message: "name must exist"
      end

      let(:database) { ModelWithValidation.database }

      around(:each) do |example|
        begin
          database.create
          ModelWithValidation.upload_validation!
          example.run
        ensure
          database.drop
        end
      end

      let(:valid_record) { ModelWithValidation.new(name: "Name") }
      let(:invalid_record) { ModelWithValidation.new }

      it "should allow to store valid record" do
        valid_record.save.should be_true
        valid_record.errors.should be_blank
      end

      it "shouldn't allow to store invalid record" do
        invalid_record.save.should be_false
      end

      it "should store errors" do
        invalid_record.save
        invalid_record.errors.should eq(["name must exist"])
      end

    end
  end
end