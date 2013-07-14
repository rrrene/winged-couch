require 'spec_helper'

describe CouchORM::HTTP, :couch do

  let(:http) { CouchORM::HTTP }
  let(:test_db_url) { "#{couch_db_server}/test_db" }
  let(:test_data) { { :asd => "qwe" }.to_json }

  after(:each) { http.delete(test_db_url) rescue nil }

  context "returning value" do
    it ".get" do
      response = http.get(couch_db_server)
      response["couchdb"].should eq("Welcome")
    end

    it ".post" do
      http.put(test_db_url)
      response = http.post(test_db_url, test_data)
      response["ok"].should be_true
      response.should have_key "id"
    end

    it ".put" do
      response = http.put(test_db_url)
      response.should eq success_response
    end

    it ".delete" do
      http.put(test_db_url)
      response = http.delete(test_db_url)
      response.should eq success_response
    end
  end

  context "with a block" do
    it ".get" do
      expect { |block| http.get(couch_db_server, &block) }.to yield_with_args(Hash)
    end

    it ".post" do
      http.put(test_db_url)

      expect { |block| http.post(test_db_url, test_data, &block) }.to yield_with_args(Hash)
    end

    it ".put" do
      expect { |block| http.put(test_db_url, &block) }.to yield_with_args(success_response)
    end

    it ".delete" do
      http.put(test_db_url)
      expect { |block| http.delete(test_db_url, &block) }.to yield_with_args(success_response)
    end

  end

end