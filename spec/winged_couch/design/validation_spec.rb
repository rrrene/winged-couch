require 'spec_helper'

module WingedCouch
  module Design
    describe Validation, :with_model do

      model :TestModel do
        attribute :name, String
        attribute :age,  Fixnum
      end

      let(:name_validation_message) { "name can't be blank" }
      let(:age_validation_message) { "age can't be blank" }

      let(:name_validation) { "function(newDoc) { if (newDoc.name == null) throw({forbidden: \"#{name_validation_message}\"}) }" }
      let(:age_validation)  { "function(newDoc) { if (newDoc.age  == null) throw({forbidden: \"#{age_validation_message}\"}) }" }

      it "uploads validation function to specified database" do
        Validation.upload(database, :name, name_validation)
        HTTP.get(database.path.join("_design/validation_name"))["validate_doc_update"].should eq(name_validation)
      end

      it "stores multiple validations for same model" do
        Validation.upload(database, :name, name_validation)
        Validation.upload(database, :age, age_validation)
        HTTP.get(database.path.join("_design/validation_name"))["validate_doc_update"].should eq(name_validation)
        HTTP.get(database.path.join("_design/validation_age"))["validate_doc_update"].should eq(age_validation)
      end

      context "validates insertions" do
        before do
          Validation.upload(database, :name, name_validation)
          Validation.upload(database, :age, age_validation)
        end

        let(:invalid_record) { TestModel.new }
        let(:valid_record) { TestModel.new(name: "Name", age: 45) }

        it "doesn't allow to insert invalid records" do
          invalid_record.save.should be_false
          invalid_record.native_document.errors.should eq([name_validation_message])

          invalid_record.name = "Name"
          invalid_record.save.should be_false
          invalid_record.native_document.errors.should eq([age_validation_message])

          invalid_record.age = 100
          invalid_record.save.should be_true
        end

        it "allows to insert valid records" do
          valid_record.save
          expect { valid_record.native_document.exist? }.to be_true
        end

      end

    end
  end
end