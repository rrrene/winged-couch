require 'spec_helper'

module WingedCouch
  module Models
    describe API, :with_model do

      model :OneFieldModel do
        attribute :field, String
      end

      subject(:record) { OneFieldModel.new(field: "value") }

      describe "#new" do
        its(:field) { should eq("value") }
      end

      it ".create" do
        expect { record.save }.to change { record._id }
      end

      describe "#inspect" do
        let(:expected) { %Q{#<OneFieldModel field: "value", _id: nil, _rev: nil>} }
        its(:inspect) { should eq(expected) }
      end

      describe ".find" do
        before { record.save }

        it "finds record by id" do
          OneFieldModel.find(record._id).should eq(record)
        end
      end

      describe "#update" do
        before { record.save }

        it "updates data in record" do
          expect { record.update(field: "value1") }.to change { record.field }
        end

        it "saves record" do
          expect { record.update(field: "value1") }.to change { record._rev }
        end
      end

    end
  end
end