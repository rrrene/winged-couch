require 'spec_helper'

module WingedCouch
  module Native
    describe Document, :with_database do

      let(:database) { Database.new("test") }
      let(:document_id) { "document_id" }
      let(:data) { { key: "value", _id: document_id } }
      subject(:document) { Document.new(database, data) }
      let(:data_with_revision) { data.merge(_rev: "revision") }
      let(:document_with_revision) { Document.new(database, data_with_revision) }

      describe "#save" do
        it "saves document to database" do
          document.save
          database.documents_count.should_not == 0
        end
      end

      describe "#exist?" do
        context "when document wasn't saved" do
          its(:exist?) { should be_false }
        end

        context "when document was saved" do
          before { document.save }
          its(:exist?) { should be_true }
        end
      end

      describe "#fetch_revision!" do
        context "when document wasn't saved" do
          it "raises exception" do
            expect { document.fetch_revision! }.to raise_error(Exceptions::DocumentMissing)
          end
        end

        context "when document was saved" do
          before { document.save }

          it "updates revision" do
            document.should_receive(:_rev=).with(instance_of(String))
            document.fetch_revision!
          end
        end
      end


      describe "#reload" do
        before do
          document.save
          document.data["key"] = "value2"
          document.reload
        end

        it "updates document with latest data in database" do
          document.data[:key].should eq("value")
        end
      end

      describe "#delete" do

        context "when document exist" do
          before do
            document.save
            database.documents_count.should eq(1)
          end

          it "removes document" do
            document.delete
            database.documents_count.should eq(0)
          end

          it "flushes revision" do
            document.delete
            document._rev.should be_nil
          end
        end

        it "raises exception if document doesn't exist" do
          expect { document.delete }.to raise_error(Exceptions::DocumentMissing)
        end
      end

      describe "#update" do
        before do
          document.save
          database.documents_count.should eq(1)
        end

        it "updates document" do
          document.update(key: "value2")
          database.documents_count.should eq(1)
          document.data[:key] = "value2"
        end
      end

      describe ".find" do
        context "when document exist" do
          before { document.save }

          it "finds the document in the database" do
            Document.find(database, document._id).should eq(document)
          end
        end

        context  "when document doesn't exist" do
          it "raises exception" do
            expect { Document.find(database, "missing-id") }.to raise_error(Exceptions::DocumentMissing)
          end
        end
      end

      describe "#errors" do
        context "when document was saved" do
          before { document.save }

          it "return blank array" do
            document.errors.should eq([])
          end
        end

        context "when document wasn't saved" do
          let(:error_message) { "Name can't be blank" }
          let(:validation) do
            %Q{
              function(newDoc) {
                if (newDoc.name == null)
                  throw({forbidden: "#{error_message}"})
                }
            }
          end

          before do
            Design::Validation.upload(database, :name, validation)
            document.save
          end

          it "returns list of errors" do
            document.errors.should eq([error_message])
          end

        end
      end

    end

  end
end