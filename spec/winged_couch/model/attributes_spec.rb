require 'spec_helper'

module WingedCouch
  module Models
    describe Attributes do

      UnsupportedClass = Class.new

      class SimpleModel < WingedCouch::Model
        attribute :name, String
        attribute :gender, Symbol, default: "male"
        attribute :number, Fixnum
        attribute :unsupported, UnsupportedClass
      end

      it ".attribute_names" do
        SimpleModel.attribute_names.should eq [:name, :gender, :number, :unsupported]
      end

      describe "#attributes" do
        let(:attributes) { { name: "name", gender: :gender, number: 123 } }
        let(:expected_attributes) { attributes.merge(unsupported: nil) }

        subject(:record) { SimpleModel.new(attributes) }

        its(:attributes) { should eq(expected_attributes) }
      end

      describe "#attribute" do
        subject(:record) { SimpleModel.new }

        context "default value" do
          context "type casting allowed" do
            its(:gender) { should eq("male") }
          end

          it "raises error if type casting doesn't allowed" do
            expect { record.unsupported = nil }.to raise_error(Exceptions::UnsupportedType)
          end
        end
      end

    end
  end
end