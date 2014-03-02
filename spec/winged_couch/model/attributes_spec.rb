require 'spec_helper'

module WingedCouch
  module Models
    describe Attributes, :with_model do

      model :SimpleModel do
        attribute :name, String
        attribute :gender, Symbol, default: :male
        attribute :age, Fixnum
      end

      subject(:model) { SimpleModel }

      its(:attribute_names) { should eq [:name, :gender, :age] }

      describe "#attributes" do
        context "when data is filled" do
          let(:data) { { name: "John", gender: "male", age: 25 } }
          subject(:record) { SimpleModel.new(data) }
          let(:expected) { { name: "John", gender: :male, age: 25 } }
          its(:attributes) { should eq(expected) }
        end

        context "when data is not filled" do
          subject(:record) { SimpleModel.new }
          let(:expected) { { name: nil, gender: :male, age: nil } }
          its(:attributes) { should eq(expected) }
        end
      end

    end
  end
end