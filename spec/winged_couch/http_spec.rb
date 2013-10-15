require 'spec_helper'

module WingedCouch
  describe HTTP, :flush_dbs do

    let(:test_data) { { field: "value" } }
    let(:root_path) { WingedCouch::HttpPath.new }
    let(:db_path) { root_path.join("test_db") }
    let(:success_response) { { "ok" => true } }

    context "returning value" do
      it ".get" do
        response = HTTP.get(root_path)
        response["couchdb"].should eq("Welcome")
      end

      it ".put" do
        response = HTTP.put(db_path)
        response.should eq success_response
      end

      it ".post" do
        HTTP.put(db_path)
        response = HTTP.post(db_path, test_data)
        response["ok"].should be_true
        response.should have_key "id"
      end

      it ".delete" do
        HTTP.put(db_path)
        response = HTTP.delete(db_path)
        response.should eq success_response
      end
    end

  end
end