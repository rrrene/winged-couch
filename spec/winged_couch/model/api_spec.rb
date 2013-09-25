require 'spec_helper'

describe WingedCouch::Models::API do

  let(:database) { OneFieldModel.database }
  let(:record) { OneFieldModel.new(field: "value") }

  around(:each) do |example|
    begin
      database.create
      example.run
    ensure
      database.drop
    end
  end

  it "#new" do
    record.field.should eq "value"
  end

  it ".create" do
    record_id = OneFieldModel.create(field: "value")._id
    database.get("/" + record_id).should be_a(Hash)
  end

  it "#inspect" do
    record.inspect.should eq "#<OneFieldModel field: \"value\", _id: nil, _rev: nil>"
  end

  it ".find" do
    record = OneFieldModel.create(field: 'value')
    OneFieldModel.find(record._id).should eq(record)
  end

  it "#update" do
    record = OneFieldModel.create(field: 'value1')
    record.update(field: 'value2')
    OneFieldModel.find(record._id).field.should eq('value2')
    record.field.should eq('value2')
  end

end