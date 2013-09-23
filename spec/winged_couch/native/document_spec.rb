require 'spec_helper'

module WingedCouch
  module Native
    describe Document do

      let(:database) { Database.new("test") }
      let(:document_id) { "document_id" }
      let(:data) { { key: "value", _id: document_id } }
      subject(:document) { Document.new(database, data) }
      let(:data_with_revision) { data.merge(_rev: "revision") }
      let(:document_with_revision) { Document.new(database, data_with_revision) }

      around(:each) do |example|
        begin
          database.create
          example.run
        ensure
          database.drop
        end
      end

      describe "#initialize" do
        describe "storing passsed data" do
          subject(:document) { Document.new(database, data) }
          its(:database) { should eq(database) }
          its(:data)     { should have_key(:key) }
        end

        describe "retrieving revision" do
          let(:retrieved_document) { Document.new(database, data) }

          context "when document exist in database" do
            before { document.save }

            it "retrieves revision" do
              retrieved_document.data[:_rev].should_not be_blank
            end
          end

          context "when document doesn't exist in database" do
            it "doesn't retrieves revision" do
              retrieved_document.data[:_rev].should be_blank
            end
          end
          
        end
      end

      describe "#_id" do
        it "returns document id" do
          document._id.should eq(document_id)
        end
      end

      describe "#_rev" do
        it "returns revision of document (blank by default)" do
          document._rev.should be_nil
        end

        it "fills after saving document" do
          document.save
          document._rev.should be_a(String)
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

      describe "#get" do
        context "when document wasn't saved" do
          its(:get) { should be_nil }
        end

        context "when document was saved" do
          before { document.save }

          its(:get) { should be_a(Hash) }
        end
      end

      describe "#revision" do
        context "when document wasn't saved" do
          its(:revision) { should be_nil }
        end

        context "when document was saved" do
          before { document.save }
          its(:revision) { should be_a(String) }
        end
      end

      describe "#save" do
        it "saves document to database" do
          document.save
          database.documents_count.should_not == 0
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

      describe "#inspect" do
        context "when document saved" do
          before { document.save }
          let(:expected) { %{#<WingedCouch::Native::Document database="test", _id="document_id", _rev="1-59414e77c768bc202142ac82c2f129de", key="value">} }
          its(:inspect) { should eq(expected) }
        end

        context "when document wasn't saved" do
          let(:expected) { %{#<WingedCouch::Native::Document database="test", _id="document_id", _rev=nil, key="value">} }
          its(:inspect) { should eq(expected) }
        end

        context "blank record" do
          let(:expected) { %{#<WingedCouch::Native::Document database="test", _id=nil, _rev=nil>} }
          subject(:document) { Document.new(database) }
          its(:inspect) { should eq(expected) }
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
        context "when document exist" do
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

        context "when document doesn't exist" do
          it "raises exception when document doesn't exist" do
            expect { document.update(key: "value2") }.to raise_error(Exceptions::DocumentMissing)
          end

          it "doesn't updates instance" do
            document.update(key: "value2") rescue nil
            document.data[:key].should_not eq("value2")
          end
        end
      end

    end

  end
end