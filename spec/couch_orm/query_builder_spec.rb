require 'spec_helper'

describe CouchORM::QueryBuilder do
  let(:default_builder) { described_class.new }
  let(:database) { CouchORM::Database.new("db") }

  context "not configured" do
    subject(:builder) { default_builder }

    its(:database)    { should be_nil }
    its(:path)        { should be_nil }
    its(:params)      { should eq({}) }
    its(:http_method) { should eq("get") }
  end

  context "configured" do
    subject(:builder) {
      default_builder.
        with_database(database).
        with_path("path").
        with_param(:limit, 100).
        with_http_method("post")
    }

    its(:database)    { should eq(database) }
    its(:path)        { should eq("path") }
    its(:params)      { should eq({limit: 100}) }
    its(:http_method) { should eq("post") }
  end

  context "#perform" do
    let(:custom_builder) {
      default_builder.with_database(database).with_param(:key, "value").with_path("/path")
    }

    let(:get_builder)  { custom_builder.with_http_method("get") }
    let(:post_builder) { custom_builder.with_http_method("post") }

    it "GET" do
      database.should_receive("get").with("/path?key=value")
      get_builder.perform
    end

    it "POST" do
      database.should_receive("post").with("/path", { key: "value" })
      post_builder.perform
    end
  end

  it "validation" do
    expect { default_builder.perform }.to raise_error
  end
end