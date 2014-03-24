require 'spec_helper'

# TODO
# Change all expectation to checking for proper delegation to native document.


module WingedCouch
  module Models
    describe Persistence, :with_model do

      model :TestModel do
        attribute :field, String
      end
      
      let(:record) { TestModel.new(field: "value") }

      describe ".database" do
        subject(:model) { TestModel }
        its(:database) { should be_a(Native::Database) }

        it "should automatically create database if it doesn't exist" do
          expect(TestModel.database.exist?).to be_true
        end
      end

      describe "#save" do

        it "should set _id if object is new" do
          expect { record.save }.to change { record._id }.from(nil).to(instance_of(String))
        end

        it "should update record in db" do
          expect { record.save }.to change { record._rev }
        end

        it "should mark object as persisted" do
          expect { record.save }.to change { record.persisted? }.from(false).to(true)
        end

        context "when object was not saved" do
          # break the object
          before { record.native_document.data[:_rev] = "wrong-rev" }

          it "raises an error" do
            expect { record.save }.to raise_error
          end
        end

      end

      describe "#delete" do
        context "when object exist" do
          before { record.save }

          it "removes record from db" do
            WingedCouch::HTTP.should_receive(:delete)
            record.delete
          end

          it "unmarks object as persisted" do
            expect { record.delete }.to change { record.persisted? }.from(true).to(false)
          end
        end

        context "when object doesn't exist" do
          # break the object
          before { record.native_document.data[:_id] = "wrong-id" }

          it "raises error" do
            expect { record.delete }.to raise_error
          end
        end

      end

      describe "#update" do
        before { record.save }

        context "when record exist" do
          it "updates record" do
            expect { record.update(field: "value2") }.to change { record.field }.to("value2")
          end

          it "updates document in CouchDB" do
            WingedCouch::HTTP.should_receive(:put).and_return(Hash.new)
            record.update(field: "value2")
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

  end
end
