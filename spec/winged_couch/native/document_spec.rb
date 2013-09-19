require 'spec_helper'

describe WingedCouch::Native::Document do


  around(:each) do |example|
    begin
      database.create
      example.run
    ensure
      database.drop
    end
  end

  let(:database) { WingedCouch::Native::Database.new("test") }

  let(:document_id) { "document_id" }

  let(:data) { { key: "value", _id: document_id } }
  let(:document) { WingedCouch::Native::Document.new(database, data) }

  let(:data_with_revision) { data.merge({ _rev: "revision" }) }
  let(:document_with_revision) { WingedCouch::Native::Document.new(database, data_with_revision) }

  let(:documents_count) { lambda { database.get("/")["doc_count"] } }

  describe "#initialize" do
    it "stores passsed database and parameters" do
      document.database.should eq(database)
      document.data[:key].should eq("value")
    end

    it "retrieves revision if it's blank" do
      document.save
      WingedCouch::Native::Document.new(database, data).data[:_rev].should_not be_blank
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
    it "returns false if document wasn't saved to database" do
      document.exist?.should be_false
    end

    it "returns true if document was saved" do
      document.save
      document.exist?.should be_true
    end
  end

  describe "#get" do
    it "returns nil if document wasn't saved in database" do
      document.get.should be_nil
    end

    it "retrieves data about document from database" do
      document.save
      document.get.should be_a(Hash)
    end
  end

  describe "#revision" do
    it "returns nil if document wasn't saved" do
      document.revision.should be_nil
    end

    it "fetches latest revision from database" do
      document.save
      document.revision.should be_a(String)
    end
  end

  describe "#save" do
    it "saves document to database" do
      document.save
      documents_count.call.should_not eq(0)
    end
  end

  describe "#reload" do
    before do
      document.save
      document.data["key"] = "value2"
    end

    it "updates document with latest data in database" do
      document.reload.data[:key].should eq("value")
    end
  end

  describe "#inspect" do
    it "displays correctly" do
      document.save
      expected = %{#<WingedCouch::Native::Document database="test", _id="document_id", _rev="1-59414e77c768bc202142ac82c2f129de", key="value">}
      document.inspect.should eq(expected)
    end
  end

  describe "#delete" do

    context "when document exist" do
      before do
        document.save
        documents_count.call.should eq(1)
      end

      it "removes document from database" do
        document.delete
        documents_count.call.should eq(0)
      end

      it "flushes revision" do
        document.delete
        document._rev.should be_nil
      end
    end

    it "raises exception if document doesn't exist" do
      expect { document.delete }.to raise_error(WingedCouch::Exceptions::DocumentMissing)
    end
  end

  describe "#update" do
    context "when document exist" do
      before do
        document.save
        documents_count.call.should eq(1)
      end

      it "updates document" do
        document.update(key: "value2")
        documents_count.call.should eq(1)
        document.data[:key] = "value2"
      end
    end

    context "when document doesn't exist" do
      it "raises exception when document doesn't exist" do
        expect { document.update(key: "value2") }.to raise_error(WingedCouch::Exceptions::DocumentMissing)
      end

      it "doesn't updates instance" do
        document.update(key: "value2") rescue nil
        document.data[:key].should_not eq("value2")
      end
    end
  end

end