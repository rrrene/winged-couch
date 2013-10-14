require 'spec_helper'

describe WingedCouch::HTTP do

  let(:http) { WingedCouch::HTTP }
  let(:test_data) { { field: "value" } }
  let(:root_path) { WingedCouch::HttpPath.new }
  let(:db_path) { root_path.join("test_db") }
  let(:success_response) { { "ok" => true } }

  around(:each) do |example|
    begin
      example.run
    ensure
      http.delete(db_path) rescue nil
    end
  end

  context "returning value" do
    it ".get" do
      response = http.get(root_path)
      response["couchdb"].should eq("Welcome")
    end

    it ".put" do
      response = http.put(db_path)
      response.should eq success_response
    end

    it ".post" do
      http.put(db_path)
      response = http.post(db_path, test_data)
      response["ok"].should be_true
      response.should have_key "id"
    end

    it ".delete" do
      http.put(db_path)
      response = http.delete(db_path)
      response.should eq success_response
    end
  end

end